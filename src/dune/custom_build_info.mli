open! Stdune

type t =
  { loc : Loc.t
  ; module_ : Module_name.t
  ; max_size : int
  ; link_time_action : Loc.t * Action_dune_lang.t
  }

val decode : (t, Dune_lang.Decoder.values) Dune_lang.Decoder.parser
