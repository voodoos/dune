let decode () =
  let open Dune_lang.Decoder in
  field "custom_build_info" (return ())
