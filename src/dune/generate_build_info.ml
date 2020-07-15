
open !Stdune

let pr buf fmt = Printf.bprintf buf (fmt ^^ "\n")

let setup_rules ~sctx ~dir (def:Dune_file.Generate_custom_build_info.t) =
  let buf = Buffer.create 1024 in
  (* if def.sourceroot then sourceroot_code buf;
  if def.relocatable then relocatable_code buf;
  let sites =
    List.sort_uniq
      ~compare:(fun (_,pkga) (_,pkgb) -> Package.Name.compare pkga pkgb)
      (def.sites@(List.map ~f:(fun (loc,(pkg,_)) -> (loc,pkg)) def.plugins))
  in
  if List.is_non_empty sites then begin
    pr buf "module Sites = struct";
    List.iter sites ~f:(sites_code sctx buf);
    pr buf "end"
  end;
  let plugins = Package.Name.Map.of_list_multi (List.map ~f:snd def.plugins) in
  if not (Package.Name.Map.is_empty plugins) then begin
    pr buf "module Plugins = struct";
    Package.Name.Map.iteri plugins ~f:(plugins_code sctx buf);
    pr buf "end"
  end; *)
  pr buf "val custom : string";
  let mli = Buffer.contents buf in
  let module_ = (Module_name.to_string def.module_) ^ ".mli" in
  let file = Path.Build.relative dir module_ in
  Super_context.add_rule
    sctx
    ~dir
    (Build.write_file file mli);
  module_
