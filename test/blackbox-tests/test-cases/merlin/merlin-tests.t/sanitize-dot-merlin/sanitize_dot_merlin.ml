open Printf

let process_line =
  let path_re = Str.regexp {|\((1:[SB]\)[0-9]+:/[^)]+/lib\(/?[^)]*)\)|} in
  let ppx_re = Str.regexp {|\((3:FLG\)[0-9]+:-ppx '/[^)]+/\.ppx/\([^)]+)\)|} in
  (* let special_pp_re =
    Str.regexp {|\((3:FLG\)[0-9]+:-pp '/[^)]+/_build/install/default/bin/\([^)]+)\)|}
  in *)
  let endline_re = Str.regexp {|)(|} in
  let sizes_re = Str.regexp {|[0-9]+:|} in
  fun line ->
    line
    (* 
    |> Str.global_replace special_pp_re "\\1 -pp '$BIN/\\2" *)
    |> Str.global_replace ppx_re "\\1?:-ppx '$PPX/\\2"
    |> Str.global_replace path_re "\\1?:$LIB_PREFIX/lib\\2"
    |> Str.global_replace endline_re ")\n("
    |> Str.global_replace sizes_re "?:"

let () =
  let files = Sys.argv |> Array.to_list |> List.tl |> List.sort compare in
  List.iter
    (fun f ->
      printf "# Processing %s\n" f;
      let ch = open_in f in
      let rec all_lines lines =
        match input_line ch with
        | exception End_of_file -> lines
        | line -> all_lines (process_line line :: lines)
      in
      all_lines [] |> List.sort compare |> List.iter print_endline;
      close_in ch)
    files
