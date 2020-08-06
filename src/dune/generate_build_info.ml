open! Stdune

let pr buf fmt = Printf.bprintf buf (fmt ^^ "\n")

let setup_rules ~sctx ~dir (def : Dune_file.Generate_custom_build_info.t) =
  let buf = Buffer.create 1024 in
  pr buf "val custom : string";
  let mli = Buffer.contents buf in
  let module_ = Module_name.uncapitalize def.module_ ^ ".mli" in
  let file = Path.Build.relative dir module_ in
  Super_context.add_rule sctx ~dir (Build.write_file file mli);
  module_

let is_cbi_module sctx ~dir (module_ : Module.t) =
  match Super_context.stanzas_in sctx ~dir with
  | Some { data = stanzas; _ } ->
    List.fold_left ~init:false
      ~f:(fun acc -> function
        | Dune_file.Generate_custom_build_info cbi ->
          let has_same_name =
            Ordering.is_eq
              (Module_name.compare cbi.module_ (Module.name module_))
          in
          acc || has_same_name
        | _ -> acc)
      stanzas
  | None -> false

let cbi_modules sctx ~dir =
  match Super_context.stanzas_in sctx ~dir with
  | Some { data = stanzas; _ } ->
    List.filter_map
      ~f:(function
        | Dune_file.Generate_custom_build_info cbi -> Some cbi
        | _ -> None)
      stanzas
  | None -> []
