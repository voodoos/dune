open! Stdune

val output_file : string -> string

val setup_rules :
     sctx:Super_context.t
  -> dir:Path.Build.t
  -> Dune_file.Generate_custom_build_info.t
  -> string

val cbi_modules :
  Compilation_context.t -> Dune_file.Generate_custom_build_info.t list

val expand :
     cctx:Compilation_context.t
  -> string
  -> Dune_file.Generate_custom_build_info.t
  -> Dune_engine.Action.t Dune_engine.Build.With_targets.t
