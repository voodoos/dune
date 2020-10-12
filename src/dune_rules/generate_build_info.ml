open! Stdune
open Dune_engine
open Dune_file.Generate_custom_build_info

let output_file name = Printf.sprintf ".%s_custom_build_info.txt-gen" name

let pr buf fmt = Printf.bprintf buf (fmt ^^ "\n")

let setup_rules ~sctx ~dir (def : t) =
  let buf = Buffer.create 1024 in
  pr buf "val custom : string option";
  let mli = Buffer.contents buf in
  let module_ = Module_name.uncapitalize def.module_ ^ ".mli" in
  let file = Path.Build.relative dir module_ in
  Super_context.add_rule sctx ~dir (Build.write_file file mli);
  module_

let cbi_modules cctx =
  let sctx = Compilation_context.super_context cctx in
  let modules = Compilation_context.modules cctx in
  match Super_context.stanzas_in sctx ~dir:(Compilation_context.dir cctx) with
  | Some { data = stanzas; _ } ->
    List.filter_map
      ~f:(function
        | Dune_file.Generate_custom_build_info cbi -> (
          match Modules.find modules cbi.module_ with
          | Some _ -> Some cbi
          | None -> None )
        | _ -> None)
      stanzas
  | None -> []

let expand ~cctx name { link_time_action = loc, action; _ } =
  let dir = Compilation_context.dir cctx in
  let raw_filename = output_file name in
  let filename = String_with_vars.make_text Loc.none raw_filename in
  let action = Action_unexpanded.with_stdout_to filename action in
  let path = Path.Build.relative dir raw_filename in
  let targets =
    Targets.Static
      { targets = [ path ]; multiplicity = Targets.Multiplicity.One }
  in
  Action_unexpanded.expand action ~loc ~dep_kind:Required ~targets_dir:dir
    ~targets:Targets.(Or_forbidden.Targets targets)
    ~expander:(Compilation_context.expander cctx)
    (Build.return Bindings.empty)
