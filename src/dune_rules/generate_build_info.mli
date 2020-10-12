open! Stdune
open Dune_engine

type kind =
  | Exe
  | Lib of Module_name.t option

val output_file : kind -> Mode.t -> string -> string

val setup_rules :
     sctx:Super_context.t
  -> dir:Path.Build.t
  -> Dune_file.Generate_custom_build_info.t
  -> string

val cbi_modules :
  Compilation_context.t -> Dune_file.Generate_custom_build_info.t list

(* val expand : cctx:Compilation_context.t -> string -> Mode.t ->
   Dune_file.Generate_custom_build_info.t -> Dune_engine.Action.t
   Dune_engine.Build.With_targets.t *)

val build_action :
     Compilation_context.t
  -> ?kind:kind
  -> Mode.t
  -> Action.t Build.With_targets.t list
