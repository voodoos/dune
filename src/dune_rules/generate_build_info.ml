open! Stdune
open Dune_engine

let output_file name = Printf.sprintf ".%s_custom_build_info.txt-gen" name

let pr buf fmt = Printf.bprintf buf (fmt ^^ "\n")

let setup_rules ~sctx ~dir (def : Dune_file.Generate_custom_build_info.t) =
  let buf = Buffer.create 1024 in
  pr buf "val custom : string option";
  let mli = Buffer.contents buf in
  let module_ = Module_name.uncapitalize def.module_ ^ ".mli" in
  let file = Path.Build.relative dir module_ in
  Super_context.add_rule sctx ~dir (Build.write_file file mli);
  module_

let cbi_modules cctx ~modules =
  let sctx = Compilation_context.super_context cctx in
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
