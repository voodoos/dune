(** OCaml module compilation *)

open Import

module Precompiled_cmi : sig
  type t =
    | No
    | External
    | Generated
end

(** Setup rules to build a single module.*)
val build_module :
     dep_graphs:Dep_graph.Ml_kind.t
  -> ?precompiled_cmi:Precompiled_cmi.t
  -> Compilation_context.t
  -> Module.t
  -> unit

val ocamlc_i :
     ?flags:string list
  -> dep_graphs:Dep_graph.Ml_kind.t
  -> Compilation_context.t
  -> Module.t
  -> output:Path.Build.t
  -> unit

val build_all : Compilation_context.t -> dep_graphs:Dep_graph.Ml_kind.t -> unit
