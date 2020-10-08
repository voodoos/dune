open! Stdune

val setup_rules :
     sctx:Super_context.t
  -> dir:Path.Build.t
  -> Dune_file.Generate_custom_build_info.t
  -> string
