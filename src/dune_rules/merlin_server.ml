open! Dune_engine
open! Stdune
open Import

module Merlin_conf = struct
  type t = Sexp.t

  let make_error msg = Sexp.(List [ List [ Atom "ERROR"; Atom msg ] ])

  let parse content filename : t =
    let parts = String.split content ~on:'\n' in
    let rec aux = function
      | []
      | [ _ ] ->
        make_error "Unexpected merlin-conf content"
      | file :: config :: _tl when String.equal file filename -> (
        match Csexp.parse_string config with
        | Ok (Sexp.List sexps) -> Sexp.List sexps
        | _ -> Sexp.List [] )
      | _file :: _config :: tl -> aux tl
    in
    aux parts

  let to_stdout (t : t) =
    Csexp.to_channel stdout t;
    flush stdout
end

module Commands = struct
  type t =
    | File of string
    | Halt
    | Unknown of string

  let read_input in_channel =
    match Csexp.input in_channel with
    | Ok sexp -> (
      let open Sexp in
      match sexp with
      | Atom "Halt" -> Halt
      | List [ Atom "File"; Atom path ] -> File path
      | sexp ->
        let msg = Printf.sprintf "Bad input: %s" (Sexp.to_string sexp) in
        Unknown msg )
    | Error _ -> Halt
end

(* [to_local p] makes absolute path [p] relative to the projects root and
   optionally removes the build context *)
let to_local abs_file_path =
  let error msg = Error msg in
  let path_opt =
    String.drop_prefix
      ~prefix:Path.(to_absolute_filename (of_local Local.root))
      abs_file_path
  in
  match path_opt with
  | Some path -> (
    try Ok Path.(Filename.concat "." path |> of_string |> local_part)
    with _ -> Printf.sprintf "Could not resolve path %s" path |> error )
  | None ->
    Printf.sprintf "Path is not in dune workspace %s" abs_file_path |> error

let get_context_root () =
  let workspace = Workspace.workspace () in
  let context =
    Option.value ~default:Context_name.default workspace.merlin_context
  in
  let ctx = Context_name.to_string context in
  Path.Build.(relative root ctx)

let load_merlin_file path file =
  let ctx_root = get_context_root () in
  let filename = Filename.remove_extension file |> String.lowercase in

  let no_config_error () =
    Merlin_conf.make_error "Project isn't built. (Try calling `dune build`.)"
  in

  let dir_path = Path.Build.(append_local ctx_root path) in
  let file_path = Path.Build.relative dir_path Merlin.merlin_file_name in
  if Path.(exists (build file_path)) then
    let build = Build.contents (Path.build file_path) in
    let content, _ = Build.exec build in
    Merlin_conf.parse content filename
  else
    no_config_error ()

let print_merlin_conf file =
  let abs_root, file = Filename.(dirname file, basename file) in
  let answer =
    match to_local abs_root with
    | Ok p -> load_merlin_file p file
    | Error s -> Merlin_conf.make_error s
  in
  Merlin_conf.to_stdout answer

let start () =
  let rec main () =
    match Commands.read_input stdin with
    | File path ->
      print_merlin_conf path;
      main ()
    | Unknown msg ->
      Merlin_conf.to_stdout (Merlin_conf.make_error msg);
      main ()
    | Halt -> exit 0
  in
  main ()
