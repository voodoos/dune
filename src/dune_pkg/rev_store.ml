open Stdune
open Dune_vcs
module Process = Dune_engine.Process
module Display = Dune_engine.Display
module Re = Dune_re
open Fiber.O

type t = { dir : Path.t }
type rev = Rev of string

let equal { dir } t = Path.equal dir t.dir
let display = Display.Quiet
let failure_mode = Process.Failure_mode.Strict
let output_limit = Sys.max_string_length
let make_stdout () = Process.Io.make_stdout ~output_on_success:Swallow ~output_limit
let make_stderr () = Process.Io.make_stderr ~output_on_success:Swallow ~output_limit

let run { dir } =
  let stdout_to = make_stdout () in
  let stderr_to = make_stderr () in
  let git = Lazy.force Vcs.git in
  Process.run ~dir ~display ~stdout_to ~stderr_to failure_mode git
;;

let run_capture_line { dir } =
  let git = Lazy.force Vcs.git in
  Process.run_capture_line ~dir ~display failure_mode git
;;

let run_capture_lines { dir } =
  let git = Lazy.force Vcs.git in
  Process.run_capture_lines ~dir ~display failure_mode git
;;

let run_capture_zero_separated_lines { dir } =
  let git = Lazy.force Vcs.git in
  Process.run_capture_zero_separated ~dir ~display failure_mode git
;;

let show { dir } (Rev rev) path =
  let git = Lazy.force Vcs.git in
  let failure_mode = Vcs.git_accept () in
  let command = [ "show"; sprintf "%s:%s" rev (Path.Local.to_string path) ] in
  let stderr_to = make_stderr () in
  Process.run_capture ~dir ~display ~stderr_to failure_mode git command
  >>| Result.to_option
;;

let load_or_create ~dir =
  let t = { dir } in
  let* () = Fiber.return () in
  let+ () =
    match Fpath.mkdir_p (Path.to_string dir) with
    | Already_exists -> Fiber.return ()
    | Created -> run t [ "init"; "--bare" ]
    | exception Unix.Unix_error (e, x, y) ->
      User_error.raise
        [ Pp.textf "%s isn't a directory" (Path.to_string_maybe_quoted dir)
        ; Pp.textf "reason: %s" (Unix_error.Detailed.to_string_hum (e, x, y))
        ]
        ~hints:[ Pp.text "delete this file or check its permissions" ]
  in
  t
;;

module Remote = struct
  type nonrec t =
    { repo : t
    ; handle : string
    }

  let head_branch = Re.(compile (seq [ str "HEAD branch: "; group (rep1 any); eol ]))
  let update { repo; handle } = run repo [ "fetch"; handle; "--no-tags" ]

  let default_branch { repo; handle } =
    run_capture_lines repo [ "remote"; "show"; handle ]
    >>| List.find_map ~f:(fun line ->
      Re.exec_opt head_branch line |> Option.map ~f:(fun groups -> Re.Group.get groups 1))
  ;;

  let equal { repo; handle } t = equal repo t.repo && String.equal handle t.handle

  module At_rev = struct
    type nonrec t =
      { remote : t
      ; revision : rev
      ; files_at_rev : Path.Local.Set.t
      }

    let content { remote = { repo; handle = _ }; revision; files_at_rev = _ } path =
      show repo revision path
    ;;

    let directory_entries { files_at_rev; remote = _; revision = _ } path =
      (* TODO: there are much better of implementing this:
         1. Using one [$ git show] for the entire director
         2. using libgit or ocamlgit
         3. using [$ git archive] *)
      Path.Local.Set.filter files_at_rev ~f:(fun file ->
        Path.Local.is_descendant file ~of_:path)
    ;;

    let equal { remote; revision = Rev revision; files_at_rev } t =
      let (Rev revision') = t.revision in
      equal remote t.remote
      && String.equal revision revision'
      && Path.Local.Set.equal files_at_rev t.files_at_rev
    ;;

    let repository_id { revision = Rev rev; remote = _; files_at_rev = _ } =
      Repository_id.of_git_hash rev
    ;;
  end

  let files_at_rev repo (Rev rev) =
    run_capture_zero_separated_lines repo [ "ls-tree"; "-z"; "--name-only"; "-r"; rev ]
    >>| Path.Local.Set.of_list_map ~f:Path.Local.of_string
  ;;

  let rev_of_name ({ repo; handle } as remote) ~name =
    (* TODO handle non-existing name *)
    let* rev = run_capture_line repo [ "rev-parse"; sprintf "%s/%s" handle name ] in
    let revision = Rev rev in
    let+ files_at_rev = files_at_rev repo revision in
    Some { At_rev.remote; revision = Rev rev; files_at_rev }
  ;;

  let rev_of_repository_id ({ repo; handle = _ } as remote) repo_id =
    match Repository_id.git_hash repo_id with
    | None -> Fiber.return None
    | Some rev ->
      run_capture_line repo [ "cat-file"; "-t"; rev ]
      >>= (function
      | "commit" ->
        let revision = Rev rev in
        let+ files_at_rev = files_at_rev repo revision in
        Some { At_rev.remote; revision = Rev rev; files_at_rev }
      | _ -> Fiber.return None)
  ;;
end

let remote_exists { dir } ~name =
  (* TODO read this directly from .git/config *)
  let stdout_to = make_stdout () in
  let stderr_to = make_stderr () in
  let command = [ "remote"; "show"; name ] in
  let+ (), exit_code =
    let git = Lazy.force Vcs.git in
    Process.run ~dir ~display ~stderr_to ~stdout_to Return git command
  in
  match exit_code with
  | 0 -> true
  | 128 | _ -> false
;;

let add_repo t ~source =
  (* TODO add this directly using .git/config *)
  let handle = source |> Dune_digest.string |> Dune_digest.to_string in
  let* exists = remote_exists t ~name:handle in
  let* () =
    match exists with
    | true -> Fiber.return ()
    | false -> run t [ "remote"; "add"; handle; source ]
  in
  let remote : Remote.t = { repo = t; handle } in
  let+ () = Remote.update remote in
  remote
;;
