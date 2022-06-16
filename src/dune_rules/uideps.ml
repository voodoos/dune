open Import
module CC = Compilation_context
module SC = Super_context

(** Indexing all definitions usages is a two step process:

    - first, for all compilation context we generate the uideps for all the
      modules of that cctx in the corresponding obj_dir.
    - then we aggregate all the cctx uideps *)

let ocaml_uideps sctx ~dir =
  Super_context.resolve_program ~loc:None ~dir sctx "ocaml-uideps"

let uideps_path_in_obj_dir obj_dir =
  let dir = Obj_dir.obj_dir obj_dir in
  Path.Build.relative dir "cctx.uideps"

(** This is done by calling the external binary [ocaml-uideps] which performs
    fulle shape reduction to compute the actual definition of all the occurences
    of values in the typedtree. This step is therefore dependent on all the cmts
    of those definitions are used by all the cmts of modules in this cctx. *)
let make_all cctx =
  let dir = CC.dir cctx in
  let modules =
    CC.modules cctx |> Modules.fold_no_vlib ~init:[] ~f:(fun x acc -> x :: acc)
  in
  let sctx = CC.super_context cctx in
  let obj_dir = CC.obj_dir cctx in
  let cmts =
    List.filter_map ~f:(Obj_dir.Module.cmt_file obj_dir ~ml_kind:Impl) modules
  in
  let cmts = List.map ~f:Path.build cmts in
  let fn = uideps_path_in_obj_dir obj_dir in
  let open Memo.O in
  let* ocaml_uideps = ocaml_uideps sctx ~dir in
  let context_dir = CC.context cctx |> Context.name |> Context_name.build_dir in
  SC.add_rule sctx ~dir
    (Command.run ~dir:(Path.build context_dir) ocaml_uideps
       (* TODO there are hidden deps !*)
       [ A "process-cmt"; A "-o"; Target fn; Deps cmts ])

let aggregate sctx ~dir ~target ~uideps =
  let open Memo.O in
  if List.is_empty uideps then Memo.return ()
  else
    let* ocaml_uideps = ocaml_uideps sctx ~dir in
    let uideps = List.map ~f:Path.build uideps in
    SC.add_rule sctx ~dir
      (Command.run ~dir:(Path.build dir) ocaml_uideps
         [ A "aggregate"; A "-o"; Target target; Deps uideps ])

let gen_project_rule sctx _project =
  let open Memo.O in
  let dir = (SC.context sctx).build_dir in
  let stanzas = SC.stanzas sctx in
  let* expander =
    let+ expander = Super_context.expander sctx ~dir in
    Dir_contents.add_sources_to_expander sctx expander
  in
  let* uideps =
    Dir_with_dune.deep_fold stanzas ~init:(Memo.return [])
      ~f:(fun d stanza acc ->
        let { Dir_with_dune.ctx_dir = dir; _ } = d in
        let open Dune_file in
        match
          match stanza with
          | Executables exes ->
            Some (Executables.obj_dir ~dir exes, exes.enabled_if)
            (* let obj_dir = Executables.obj_dir ~dir exes in
               uideps_path_in_obj_dir obj_dir :: acc *)
          | Library lib -> Some (Library.obj_dir ~dir lib, lib.enabled_if)
          | _ -> None
        with
        | None -> acc
        | Some (obj_dir, enabled_if) ->
          let* enabled = Expander.eval_blang expander enabled_if in
          if enabled then
            let+ acc = acc in
            uideps_path_in_obj_dir obj_dir :: acc
          else acc)
  in
  let target = Path.Build.relative dir "project.uideps" in
  let uideps_alias = Alias.uideps ~dir in
  let* () =
    Rules.Produce.Alias.add_deps uideps_alias
      (Action_builder.path @@ Path.build target)
  in
  aggregate sctx ~dir ~target ~uideps
