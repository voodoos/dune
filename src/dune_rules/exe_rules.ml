open! Dune_engine
open Import
open! No_io
open Memo.Build.O
module Executables = Dune_file.Executables

let first_exe (exes : Executables.t) = snd (List.hd exes.names)

let linkages (ctx : Context.t) ~(exes : Executables.t) ~explicit_js_mode =
  let module L = Dune_file.Executables.Link_mode in
  let l =
    let has_native = Result.is_ok ctx.ocamlopt in
    let modes =
      let add_if_not_already_present modes mode loc =
        match L.Map.add exes.modes mode loc with
        | Ok modes -> modes
        | Error _ -> modes
      in
      match L.Map.find exes.modes L.js with
      | Some loc -> add_if_not_already_present exes.modes L.byte loc
      | None -> (
        if explicit_js_mode then
          exes.modes
        else
          match L.Map.find exes.modes L.byte with
          | Some loc -> add_if_not_already_present exes.modes L.js loc
          | None -> exes.modes)
    in
    L.Map.to_list modes
    |> List.filter_map ~f:(fun ((mode : L.t), loc) ->
           match (has_native, mode) with
           | false, Other { mode = Native; _ } -> None
           | _ -> Some (Exe.Linkage.of_user_config ctx ~loc mode))
  in
  (* If bytecode was requested but not native or best version, add custom
     linking *)
  if
    L.Map.mem exes.modes L.byte
    && (not (L.Map.mem exes.modes L.native))
    && not (L.Map.mem exes.modes L.exe)
  then
    Exe.Linkage.custom ctx :: l
  else
    l

let programs ~modules ~(exes : Executables.t) =
  List.map exes.names ~f:(fun (loc, name) ->
      let mod_name = Module_name.of_string_allow_invalid (loc, name) in
      match Modules.find modules mod_name with
      | Some m ->
        if Module.has m ~ml_kind:Impl then
          { Exe.Program.name; main_module_name = mod_name; loc }
        else
          User_error.raise ~loc
            [ Pp.textf "Module %S has no implementation."
                (Module_name.to_string mod_name)
            ]
      | None ->
        User_error.raise ~loc
          [ Pp.textf "Module %S doesn't exist." (Module_name.to_string mod_name)
          ])

let o_files sctx ~dir ~expander ~(exes : Executables.t) ~linkages ~dir_contents
    ~requires_compile =
  if not (Executables.has_foreign exes) then
    Memo.Build.return Mode.Map.empty
  else
    let what =
      if List.is_empty exes.buildable.Dune_file.Buildable.foreign_stubs then
        "archives"
      else
        "stubs"
    in
    if List.mem linkages Exe.Linkage.byte ~equal:Exe.Linkage.equal then
      User_error.raise ~loc:exes.buildable.loc
        [ Pp.textf "Pure bytecode executables cannot contain foreign %s." what ]
        ~hints:
          [ Pp.text
              "If you only need to build a native executable use \"(modes \
               exe)\"."
          ];
    let* foreign_sources =
      let+ foreign_sources = Dir_contents.foreign_sources dir_contents in
      let first_exe = first_exe exes in
      Foreign_sources.for_exes foreign_sources ~first_exe
    in
    let+ o_files =
      Foreign_rules.build_o_files ~sctx ~dir ~expander
        ~requires:requires_compile ~dir_contents ~foreign_sources
      (* |> Memo.Build.all_concurrently *)
    in
    let res : Path.t Mode.Map.Multi.t = o_files in
    res

let with_empty_intf ~sctx ~dir module_ =
  let name =
    Module.file module_ ~ml_kind:Impl
    |> Option.value_exn
    |> Path.set_extension ~ext:".mli"
  in
  let rule =
    Action_builder.write_file
      (Path.as_in_build_dir_exn name)
      "(* Auto-generated by Dune *)"
  in
  let+ () = Super_context.add_rule sctx ~dir rule in
  Module.add_file module_ Ml_kind.Intf (Module.File.make Dialect.ocaml name)

let executables_rules ~sctx ~dir ~expander ~dir_contents ~scope ~compile_info
    ~embed_in_plugin_libraries (exes : Dune_file.Executables.t) =
  (* Use "eobjs" rather than "objs" to avoid a potential conflict with a library
     of the same name *)
  let* modules, obj_dir =
    let first_exe = first_exe exes in
    Dir_contents.ocaml dir_contents
    >>| Ml_sources.modules_and_obj_dir ~for_:(Exe { first_exe })
  in
  let* () = Check_rules.add_obj_dir sctx ~obj_dir in
  let ctx = Super_context.context sctx in
  let* pp =
    let instrumentation_backend =
      Lib.DB.instrumentation_backend (Scope.libs scope)
    in
    let* preprocess =
      Resolve.read_memo_build
        (Preprocess.Per_module.with_instrumentation exes.buildable.preprocess
           ~instrumentation_backend)
    in
    let* instrumentation_deps =
      Resolve.read_memo_build
        (Preprocess.Per_module.instrumentation_deps exes.buildable.preprocess
           ~instrumentation_backend)
    in
    Preprocessing.make sctx ~dir ~scope ~expander ~preprocess
      ~preprocessor_deps:exes.buildable.preprocessor_deps ~instrumentation_deps
      ~lint:exes.buildable.lint ~lib_name:None
  in
  let* modules =
    let executable_names =
      List.map exes.names ~f:Module_name.of_string_allow_invalid
    in
    Modules.map_user_written modules ~f:(fun m ->
        let name = Module.name m in
        let* m = Pp_spec.pp_module_as pp name m in
        let add_empty_intf =
          let project = Scope.project scope in
          Dune_project.executables_implicit_empty_intf project
          && List.mem executable_names name ~equal:Module_name.equal
          && not (Module.has m ~ml_kind:Intf)
        in
        if add_empty_intf then
          with_empty_intf ~sctx ~dir m
        else
          Memo.Build.return m)
  in
  let programs = programs ~modules ~exes in
  let explicit_js_mode = Dune_project.explicit_js_mode (Scope.project scope) in
  let linkages = linkages ctx ~exes ~explicit_js_mode in
  let* flags = Super_context.ocaml_flags sctx ~dir exes.buildable.flags in
  let cctx =
    let requires_compile = Lib.Compile.direct_requires compile_info in
    let requires_link = Lib.Compile.requires_link compile_info in
    let js_of_ocaml =
      let js_of_ocaml = exes.buildable.js_of_ocaml in
      if explicit_js_mode then
        Option.some_if
          (List.mem linkages Exe.Linkage.js ~equal:Exe.Linkage.equal)
          js_of_ocaml
      else
        Some js_of_ocaml
    in
    Compilation_context.create () ~super_context:sctx ~expander ~scope ~obj_dir
      ~modules ~flags ~requires_link ~requires_compile ~preprocessing:pp
      ~js_of_ocaml ~opaque:Inherit_from_settings ~package:exes.package
  in
  let stdlib_dir = ctx.Context.stdlib_dir in
  let requires_compile = Compilation_context.requires_compile cctx in
  let* preprocess =
    Resolve.read_memo_build
      (Preprocess.Per_module.with_instrumentation exes.buildable.preprocess
         ~instrumentation_backend:
           (Lib.DB.instrumentation_backend (Scope.libs scope)))
  in
  let+ () =
    (* Building an archive for foreign stubs, we link the corresponding object
       files directly to improve perf. *)
    let create_link_args mode =
      let open Action_builder.O in
      let link_flags =
        let link_deps = Dep_conf_eval.unnamed ~expander exes.link_deps in
        link_deps
        >>> Expander.expand_and_eval_set expander exes.link_flags
              ~standard:(Action_builder.return [])
      in
      let+ flags = link_flags in
      let ext_lib = ctx.lib_config.ext_lib in
      let foreign_archives =
        Mode.Dict.get exes.buildable.foreign_archives mode
      in
      Command.Args.S
        [ Command.Args.As flags
        ; Command.Args.S
            (List.map foreign_archives ~f:(fun (_, archive) ->
                 let lib =
                   Foreign.Archive.lib_file ~archive mode ~dir ~ext_lib
                 in
                 Command.Args.S [ A "-cclib"; Dep (Path.build lib) ]))
        ]
    in
    let link_args =
      let open Action_builder.O in
      let* byte = create_link_args Byte in
      let+ native = create_link_args Native in
      Mode.Dict.make ~byte ~native
    in
    let* o_files =
      o_files sctx ~dir ~expander ~exes ~linkages ~dir_contents
        ~requires_compile
    in
    (* TODO ulysse shorter ? *)
    let* () =
      Check_rules.add_files sctx ~dir
        (Mode.Map.find o_files Mode.Byte |> Option.value ~default:[])
    and* () =
      Check_rules.add_files sctx ~dir
        (Mode.Map.find o_files Mode.Native |> Option.value ~default:[])
    in
    Exe.build_and_link_many cctx ~programs ~linkages ~link_args ~o_files
      ~promote:exes.promote ~embed_in_plugin_libraries
  in
  ( cctx
  , Merlin.make ~requires:requires_compile ~stdlib_dir ~flags ~modules
      ~preprocess ~obj_dir
      ~dialects:(Dune_project.dialects (Scope.project scope))
      ~ident:(Lib.Compile.merlin_ident compile_info)
      () )

let compile_info ~scope (exes : Dune_file.Executables.t) =
  let dune_version = Scope.project scope |> Dune_project.dune_version in
  let+ pps =
    Resolve.read_memo_build
      (Preprocess.Per_module.with_instrumentation exes.buildable.preprocess
         ~instrumentation_backend:
           (Lib.DB.instrumentation_backend (Scope.libs scope)))
    >>| Preprocess.Per_module.pps
  in
  Lib.DB.resolve_user_written_deps_for_exes (Scope.libs scope) exes.names
    exes.buildable.libraries ~pps ~dune_version
    ~allow_overlaps:exes.buildable.allow_overlapping_dependencies
    ~forbidden_libraries:exes.forbidden_libraries

let rules ~sctx ~dir ~dir_contents ~scope ~expander
    (exes : Dune_file.Executables.t) =
  let* compile_info = compile_info ~scope exes in
  let f () =
    executables_rules exes ~sctx ~dir ~dir_contents ~scope ~expander
      ~compile_info ~embed_in_plugin_libraries:exes.embed_in_plugin_libraries
  in
  let* () = Buildable_rules.gen_select_rules sctx compile_info ~dir
  and* () = Bootstrap_info.gen_rules sctx exes ~dir compile_info in
  Buildable_rules.with_lib_deps
    (Super_context.context sctx)
    compile_info ~dir ~f
