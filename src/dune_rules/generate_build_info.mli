open! Stdune

val output_file : string -> string

val setup_rules :
     sctx:Super_context.t
  -> dir:Path.Build.t
  -> Dune_file.Generate_custom_build_info.t
  -> string

val cbi_modules :
     Super_context.t
  -> dir:Path.Build.w Path.Local_gen.t
  -> Dune_file.Generate_custom_build_info.t list
