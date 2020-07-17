open! Stdune

val setup_rules :
     sctx:Super_context.t
  -> dir:Path.Build.t
  -> Dune_file.Generate_custom_build_info.t
  -> string

val is_cbi_module :
  Super_context.t -> dir:Path.Build.w Path.Local_gen.t -> Module.t -> bool

val cbi_modules :
     Super_context.t
  -> dir:Path.Build.w Path.Local_gen.t
  -> Dune_file.Generate_custom_build_info.t list
