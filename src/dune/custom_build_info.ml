open! Stdune

type t =
  { loc : Loc.t
  ; module_ : Module_name.t
  ; max_size : int
  ; link_time_action : Loc.t * Action_dune_lang.t
  }

let decode =
  let open Dune_lang.Decoder in
  fields
    (let+ loc = loc
     and+ module_ = field "module" Module_name.decode
     and+ max_size = field "max_size" int
     and+ link_time_action =
       field "link_time_action" (located Action_dune_lang.decode)
     in
     { loc; module_; max_size; link_time_action })
