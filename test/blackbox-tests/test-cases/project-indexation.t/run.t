
  $ dune exec ./main.exe
  1564242

FIXME: Dune should communicate the build-path for Pmodlib to the indexer
  $ dune build @ocaml-index

  $ find . -name '*.cmt*'
  ./_build/default/implicit-lib/.imp_lib.objs/byte/imp_lib.cmt
  ./_build/default/.main.eobjs/byte/dune__exe__Othermod.cmt
  ./_build/default/.main.eobjs/byte/dune__exe.cmt
  ./_build/default/.main.eobjs/byte/dune__exe__Main.cmti
  ./_build/default/.main.eobjs/byte/dune__exe__Main.cmt
  ./_build/default/lib/.otherlib.objs/byte/otherlib.cmt
  ./_build/default/lib/.otherlib.objs/byte/otherlib.cmti
  ./_build/default/private-module/.pmodlib.objs/byte/pmodlib__.cmt
  ./_build/default/private-module/.pmodlib.objs/byte/pmodlib.cmt
  ./_build/default/private-module/.pmodlib.objs/byte/pmodlib__Pmod.cmt
  ./_build/default/vendor/otherproject/.private_lib.objs/byte/private_lib.cmt
  ./_build/default/vendor/otherproject/.vendored_lib.objs/byte/vendored_lib.cmt

  $ find . -name '*.ocaml-index'
  ./_build/default/implicit-lib/.imp_lib.objs/cctx.ocaml-index
  ./_build/default/.main.eobjs/cctx.ocaml-index
  ./_build/default/lib/.otherlib.objs/cctx.ocaml-index
  ./_build/default/project.ocaml-index
  ./_build/default/private-module/.pmodlib.objs/cctx.ocaml-index
  ./_build/default/vendor/otherproject/.private_lib.objs/cctx.ocaml-index
  ./_build/default/vendor/otherproject/.vendored_lib.objs/cctx.ocaml-index

  $ ocaml-index dump ./_build/default/project.ocaml-index
  21 uids:
  {uid: Dune__exe__Othermod.0; locs:
     "y": File "$TESTCASE_ROOT/othermod.ml", line 1, characters 4-5;
     "y": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 17-18
   uid: Pmodlib__.0; locs:
     "Pmod": File "$TESTCASE_ROOT/private-module/pmodlib.ml", line 1, characters 8-12;
     "Pmod": File "$TESTCASE_ROOT/private-module/pmodlib__.ml-gen", line 4, characters 7-11
   uid: Dune__exe__Othermod; locs:
     "Dune__exe__Othermod": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 7, characters 18-37;
     "Othermod": File "$TESTCASE_ROOT/main.ml", line 1, characters 10-18
   uid: Otherlib.1; locs:
     "Otherlib.fromotherlib": File "$TESTCASE_ROOT/main.ml", line 1, characters 28-49;
     "fromotherlib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 3, characters 4-16;
     "fromotherlib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 4, characters 29-41
   uid: Dune__exe__Othermod.1; locs:
     "other": File "$TESTCASE_ROOT/main.ml", line 1, characters 20-25;
     "other": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 4-9
   uid: Imp_lib.0; locs:
     "imp_x": File "$TESTCASE_ROOT/implicit-lib/imp_lib.ml", line 1, characters 4-9;
     "Otherlib.imp_x": File "$TESTCASE_ROOT/main.ml", line 1, characters 52-66
   uid: Imp_lib; locs:
     "Imp_lib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 6, characters 8-15;
     "Imp_lib": File "$TESTCASE_ROOT/lib/otherlib.mli", line 5, characters 24-31
   uid: Otherlib.0; locs:
     "u": File "$TESTCASE_ROOT/lib/otherlib.ml", line 1, characters 5-6
   uid: Imp_lib.1; locs:
     "t": File "$TESTCASE_ROOT/implicit-lib/imp_lib.ml", line 2, characters 5-6;
     "Imp_lib.t": File "$TESTCASE_ROOT/lib/otherlib.ml", line 1, characters 9-18;
     "Imp_lib.t": File "$TESTCASE_ROOT/lib/otherlib.mli", line 6, characters 9-18
   uid: Pmodlib__Pmod.0; locs:
     "x": File "$TESTCASE_ROOT/private-module/pmod.ml", line 1, characters 4-5
   uid: Pmodlib__.1; locs:
     "Pmodlib__": File "$TESTCASE_ROOT/private-module/pmodlib__.ml-gen", line 6, characters 7-16
   uid: Private_lib.0; locs:
     "more": File "$TESTCASE_ROOT/vendor/otherproject/private_lib.ml", line 1, characters 4-8
   uid: Stdlib.313; locs:
     "print_int": File "$TESTCASE_ROOT/main.ml", line 1, characters 0-9;
     "print_int": File "$TESTCASE_ROOT/main.ml", line 2, characters 0-9;
     "print_int": File "$TESTCASE_ROOT/main.ml", line 3, characters 0-9
   uid: Otherlib.2; locs:
     "do_something": File "$TESTCASE_ROOT/lib/otherlib.ml", line 4, characters 4-16
   uid: Pmodlib__Pmod; locs:
     "Pmodlib__Pmod": File "$TESTCASE_ROOT/private-module/pmodlib__.ml-gen", line 4, characters 14-27
   uid: Vendored_lib.0; locs:
     "Vendored_lib.value": File "$TESTCASE_ROOT/main.ml", line 2, characters 10-28;
     "value": File "$TESTCASE_ROOT/vendor/otherproject/vendored_lib.ml", line 1, characters 4-9
   uid: Stdlib.55; locs:
     "+": File "$TESTCASE_ROOT/main.ml", line 1, characters 26-27;
     "+": File "$TESTCASE_ROOT/main.ml", line 1, characters 50-51;
     "+": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 15-16
   uid: Stdlib.141; locs:
     "ignore": File "$TESTCASE_ROOT/lib/otherlib.ml", line 4, characters 22-28
   uid: Dune__exe.0; locs:
     "Main": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 4, characters 7-11
   uid: Dune__exe.1; locs:
     "Othermod": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 7, characters 7-15
   uid: Dune__exe__Main; locs:
     "Dune__exe__Main": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 4, characters 14-29
   }, 0 approx shapes: {}, and shapes for CUS .
