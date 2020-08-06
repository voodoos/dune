open! Stdune
open Ocaml_config.Ccomp_type

let base_cxx_flags =
  [ (Gcc, [ "-x"; "c++"; "-lstdc++"; "-shared-libgcc" ])
  ; (Clang, [ "-x"; "c++" ])
  ; (Msvc, [ "/TP" ])
  ]

let get_cxx_flags ccomp_type = List.assoc_opt ccomp_type base_cxx_flags

let base_c_flags (ctx : Context.t) =
  let cfg = ctx.ocaml_config in
  List.concat Ocaml_config.[ ocamlc_cflags cfg; ocamlc_cppflags cfg ]

let output_arg ccomp_type dst =
  let open Command.Args in
  match ccomp_type with
  | Msvc -> S [ Concat ("", [ A "/Fo"; Target dst ]) ]
  | _ -> S [ A "-o"; Target dst ]

let default_with_output_args ~kind (ctx : Context.t) dst =
  let ccomp_type = ctx.lib_config.ccomp_type in
  let base_flags, fdo_flags =
    match kind with
    | Dune_engine.Foreign_language.Cxx ->
      (get_cxx_flags ccomp_type |> Option.value ~default:[], Fdo.cxx_flags ctx)
    | C -> (base_c_flags ctx, Fdo.c_flags ctx)
  in
  let args =
    let open Command.Args in
    let flags = base_flags @ fdo_flags in
    S (List.map ~f:(fun f -> A f) flags)
  in
  (args, output_arg ccomp_type dst)
