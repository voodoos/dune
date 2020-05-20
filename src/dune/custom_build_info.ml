let decode () =
  let open Dune_lang.Decoder in
  field_o "custom_build_info"
    (fields (field "action" Action.decode ))
