(** {1 Handle link time code generation} *)
open! Dune_engine

open Stdune

type t =
  { to_link : Lib.Lib_and_module.L.t
  ; force_linkall : bool
  }

(** Generate link time code for special libraries such as [findlib.dynload] *)
val handle_special_libs :
     Compilation_context.t
  -> cbi:Dune_file.Generate_custom_build_info.t list
  -> t Or_exn.t

val handle_custom_build_info :
     Compilation_context.t
  -> ?kind:Generate_build_info.kind
  -> Dune_file.Generate_custom_build_info.t list
  -> Lib.Lib_and_module.t list
