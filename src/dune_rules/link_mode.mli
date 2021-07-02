(** Link mode of OCaml programs *)
open! Dune_engine

open Stdune

type t =
  | Byte
  | Native
  | Byte_with_stubs_statically_linked_in

val mode : t -> Mode.t

val equal : t -> t -> bool

module Map : sig
  type mode := t

  include Map.S with type key = t

  module Memo : sig
    val parallel_map :
      'a t -> f:(mode -> 'a -> 'b Memo.Build.t) -> 'b t Memo.Build.t
  end
end
