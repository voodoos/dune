(* open Import *)
open! Stdune
module CC = Compilation_context
module SC = Super_context

let ocaml_uideps sctx ~dir =
  Super_context.resolve_program ~loc:None ~dir sctx "ocaml-uideps"

let generate cctx (m : Module.t) =
  if Compilation_context.bin_annot cctx then
    let sctx = CC.super_context cctx in
    let dir = CC.dir cctx in
    let obj_dir = CC.obj_dir cctx in
    let cmt =
      Option.value_exn (Obj_dir.Module.cmt_file obj_dir m ~ml_kind:Impl)
      |> Path.build
    in
    let fn =
      Option.value_exn (Obj_dir.Module.uideps_file obj_dir m ~ml_kind:Impl)
    in
    let open Memo.O in
    let* ocaml_uideps = ocaml_uideps sctx ~dir in
    SC.add_rule sctx ~dir
      (Command.run ~dir:(Path.build dir) ocaml_uideps
         [ A "process-cmt"; Dep cmt; Hidden_targets [ fn ] ])
  else Memo.return ()

let aggregate cctx (modules : Module.t list) =
  if Compilation_context.bin_annot cctx then
    let sctx = CC.super_context cctx in
    let dir = CC.dir cctx in
    let obj_dir = CC.obj_dir cctx in
    let uideps_files =
      List.map modules ~f:(fun m ->
          Option.value_exn (Obj_dir.Module.uideps_file obj_dir m ~ml_kind:Impl)
          |> Path.build)
    in
    let target = Path.Build.relative (Obj_dir.dir obj_dir) "unit.uideps" in
    let open Memo.O in
    let* ocaml_uideps = ocaml_uideps sctx ~dir in
    SC.add_rule sctx ~dir
      (Command.run ~dir:(Path.build dir) ocaml_uideps
         [ A "aggregate"; A "-o"; Target target; Deps uideps_files ])
  else Memo.return ()
