(** Utop rules *)

open! Stdune

(** Return the path of the utop bytecode binary inside a directory where some
    libraries are defined. *)
val utop_exe : Path.t -> Path.t

val is_utop_dir : Path.t -> bool

val setup : Super_context.t -> dir:Path.t -> unit
