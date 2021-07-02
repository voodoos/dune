open! Dune_engine
open! Stdune

module T = struct
  type t =
    | Byte
    | Native
    | Byte_with_stubs_statically_linked_in

  let mode : t -> Mode.t = function
    | Byte -> Byte
    | Native -> Native
    | Byte_with_stubs_statically_linked_in -> Byte

  let equal x y =
    match (x, y) with
    | Byte, Byte -> true
    | Byte, _ -> false
    | _, Byte -> false
    | Native, Native -> true
    | Native, _ -> false
    | _, Native -> false
    | Byte_with_stubs_statically_linked_in, Byte_with_stubs_statically_linked_in
      ->
      true

  let compare x y =
    match (x, y) with
    | Byte, Byte
    | Native, Native
    | Byte_with_stubs_statically_linked_in, Byte_with_stubs_statically_linked_in
      ->
      Ordering.Eq
    | Byte, _ -> Lt
    | _, Byte -> Gt
    | Native, _ -> Gt
    | _, Native -> Lt

  let to_dyn = function
    | Byte -> Dyn.String "byte"
    | Native -> Dyn.String "native"
    | Byte_with_stubs_statically_linked_in ->
      Dyn.String "byte_with_stubs_statically_linked_in"
end

include T
module M = Map.Make (T)

module Map = struct
  include M
  module Memo = Memo.Build.Make_map_traversals (M)
end
