let () = Printf.printf "custom: %s\n"
  (match My_cbi.custom () with
    | None -> "n/a"
    | Some v -> My_cbi.to_string v)
