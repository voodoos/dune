open Import
module CC = Compilation_context
module SC = Super_context

let activated =
  let open Memo.O in
  let+ workspace = Workspace.workspace () in
  workspace.config.workspace_indexation = Enabled
;;

let ocaml_index sctx ~dir =
  Super_context.resolve_program_memo ~loc:None ~dir sctx "ocaml-index"
;;

let index_path_in_obj_dir ?for_cmt obj_dir =
  let dir = Obj_dir.obj_dir obj_dir in
  match for_cmt with
  | Some path ->
    let name = Path.basename path in
    Path.Build.relative dir @@ Printf.sprintf ".index/%s.ocaml-index" name
  | None -> Path.Build.relative dir "cctx.ocaml-index"
;;

let project_index ~build_dir = Path.Build.relative build_dir "project.ocaml-index"

let cctx_rules cctx =
  let open Memo.O in
  let* activated = activated in
  if not activated
  then Memo.return ()
  else (
    (* Indexing is performed by the external binary [ocaml-index] which performs
       full shape reduction to compute the actual definition of all the elements in
       the typedtree. This step is therefore dependent on all the cmts of those
       definitions are used by all the cmts of modules in this cctx. *)
    let dir = CC.dir cctx in
    let modules =
      CC.modules cctx |> Modules.fold_no_vlib ~init:[] ~f:(fun x acc -> x :: acc)
    in
    let sctx = CC.super_context cctx in
    let obj_dir = CC.obj_dir cctx in
    let cm_kind = Lib_mode.Cm_kind.(Ocaml Cmi) in
    let modules_with_cmts =
      List.filter_map
        ~f:(fun module_ ->
          Obj_dir.Module.cmt_file obj_dir ~ml_kind:Impl ~cm_kind module_
          |> Option.map ~f:(fun cmt -> Path.build cmt))
        modules
    in
    let* ocaml_index = ocaml_index sctx ~dir in
    let context_dir =
      CC.context cctx |> Context.name |> Context_name.build_dir |> Path.build
    in
    let* additionnal_libs =
      (* The indexer relies on the load_path of cmt files. When
         [implicit_transitive_deps] is set to [false] some necessary paths will
         be missing. We pass these explicitely to the index with the `-I` flag.

         The implicit transitive libs correspond to the set:
         (requires_link \ requires_link)
      *)
      let open Resolve.Memo.O in
      let* req_link = CC.requires_link cctx in
      let+ req_compile = CC.requires_compile cctx in
      let a =
        List.fold_left req_link ~init:[] ~f:(fun acc l ->
          if List.exists req_compile ~f:(Lib.equal l)
          then acc
          else (
            let dir = Lib.info l |> Lib_info.obj_dir |> Obj_dir.byte_dir in
            Command.Args.(A "-I" :: Path dir :: acc)))
      in
      Command.Args.S a
    in
    let fn = index_path_in_obj_dir obj_dir in
    let includes =
      Resolve.peek additionnal_libs
      |> Result.value ~default:Command.Args.empty
    in
    let aggregate =
      Command.run
        ~dir:context_dir
        ocaml_index
        [ A "aggregate"
        ; A "--root"
        ; A Path.(Source.root |> source |> to_absolute_filename)
        ; A "-o"
        ; Target fn
        ; Deps modules_with_cmts
        ; includes
        ]
    in
    SC.add_rule sctx ~dir aggregate)
;;

let aggregate sctx ~dir ~target ~index =
  let open Memo.O in
  if List.is_empty index
  then Memo.return ()
  else
    let* ocaml_index = ocaml_index sctx ~dir in
    let index = List.map ~f:Path.build index in
    SC.add_rule
      sctx
      ~dir
      (Command.run
         ~dir:(Path.build dir)
         ocaml_index
         [ A "aggregate"; A "-o"; Target target; Deps index ])
;;

let project_rule sctx project =
  let open Memo.O in
  let* activated = activated in
  if not activated
  then Memo.return ()
  else (
    let ctx = Super_context.context sctx in
    let build_dir = Context.build_dir ctx in
    let dir = Path.Build.append_source build_dir @@ Dune_project.root project in
    let* stanzas = Only_packages.filtered_stanzas (Context.name ctx) in
    let* expander =
      let+ expander = Super_context.expander sctx ~dir in
      Dir_contents.add_sources_to_expander sctx expander
    in
    let scope = Expander.scope expander in
    let* index =
      (* We only index public stanzas of vendored libs *)
      Dune_file.fold_stanzas
        stanzas
        ~init:(Memo.return [])
        ~f:(fun dune_file stanza acc ->
          let dir = Path.Build.append_source build_dir dune_file.dir in
          let* vendored =
            Source_tree.is_vendored (Path.Build.drop_build_context_exn dir)
          in
          let* obj =
            let open Dune_file in
            match stanza with
            | Executables exes ->
              if vendored
              then Memo.return None
              else Memo.return @@ Some (Executables.obj_dir ~dir exes, exes.enabled_if)
            | Library lib ->
              let public =
                match lib.visibility with
                | Public _ | Private None -> true
                | Private _ -> false
              in
              if vendored && not public
              then Memo.return None
              else
                let+ available =
                  if lib.optional
                  then
                    Lib.DB.available (Scope.libs scope) (Dune_file.Library.best_name lib)
                  else Memo.return true
                in
                if available
                then Some (Library.obj_dir ~dir lib, lib.enabled_if)
                else None
            | _ -> Memo.return None
          in
          match obj with
          | None -> acc
          | Some (obj_dir, enabled_if) ->
            let* enabled = Expander.eval_blang expander enabled_if in
            if enabled
            then
              let+ acc = acc in
              index_path_in_obj_dir obj_dir :: acc
            else acc)
    in
    let target = project_index ~build_dir:dir in
    let ocaml_index_alias = Alias.make Alias0.ocaml_index ~dir in
    let* () =
      Rules.Produce.Alias.add_deps ocaml_index_alias (Action_builder.path @@ Path.build target)
    in
    aggregate sctx ~dir ~target ~index)
;;
