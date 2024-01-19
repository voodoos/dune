Test the (dialect ...) stanza inside the `dune-project` file.

  $ { echo '(lang dune 3.8)'; cat dune-project.in; } >dune-project

  $ dune build --display short
  File "dune-project", line 5, characters 13-20:
  5 |   (extension cppo.ml)
                   ^^^^^^^
  Error: the possibility of defining extensions containing periods is only
  available since version 3.9 of the dune language. Please update your
  dune-project file to have (lang dune 3.9).
  [1]

  $ { echo '(lang dune 3.9)'; cat dune-project.in; } >dune-project

  $ dune build --display short 2>&1 | grep -i cppo
        ocamlc .cppo.eobjs/byte/dune__exe__Cppo.{cmi,cmti}
      ocamlopt .cppo.eobjs/native/dune__exe__Cppo.{cmx,o}
        ocamlc .cppo.eobjs/byte/dune__exe__Cppo.{cmo,cmt}
      ocamlopt cppo.exe
          cppo main.cppo.ml.ml
  File ".cppo.eobjs/_unknown_", line 1, characters 0-0:
   ocaml-index .cppo.eobjs/cctx.ocaml-index (exit 125)

  $ dune build @show
  print_endline "Hello, World"
