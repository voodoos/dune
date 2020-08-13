(** {1 Handle link time code generation} *)

open Stdune

type t =
  { to_link : Lib.Lib_and_module.L.t
  ; force_linkall : bool
  }

(** Generate link time code for special libraries such as [findlib.dynload] *)
val handle_special_libs :
     custom_build_info:Custom_build_info_old.t option
  -> Compilation_context.t
  -> t Or_exn.t

val handle_custom_build_infos :
     Compilation_context.t
  -> Custom_build_info.t list
  -> ltcg:t Or_exn.t
  -> t Or_exn.t
