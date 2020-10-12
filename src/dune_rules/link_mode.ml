open! Dune_engine
open! Stdune

type t =
  | Byte
  | Native
  | Byte_with_stubs_statically_linked_in

let mode : t -> Mode.t = function
  | Byte -> Byte
  | Native -> Native
  | Byte_with_stubs_statically_linked_in -> Byte

let of_mode = function
  | Mode.Byte -> Byte
  | Mode.Native -> Native
