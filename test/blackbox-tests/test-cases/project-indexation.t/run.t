
  $ dune exec ./main.exe
  15642

  $ dune build @ocaml-index
  $ find . -name '*.cmt'
  ./_build/default/implicit-lib/.imp_lib.objs/byte/imp_lib.cmt
  ./_build/default/.main.eobjs/byte/dune__exe__Othermod.cmt
  ./_build/default/.main.eobjs/byte/dune__exe.cmt
  ./_build/default/.main.eobjs/byte/dune__exe__Main.cmt
  ./_build/default/lib/.otherlib.objs/byte/otherlib.cmt
  ./_build/default/vendor/otherproject/.private_lib.objs/byte/private_lib.cmt
  ./_build/default/vendor/otherproject/.vendored_lib.objs/byte/vendored_lib.cmt

  $ find . -name '*.ocaml-index'
  ./_build/default/implicit-lib/.imp_lib.objs/cctx.ocaml-index
  ./_build/default/.main.eobjs/cctx.ocaml-index
  ./_build/default/lib/.otherlib.objs/cctx.ocaml-index
  ./_build/default/project.ocaml-index
  ./_build/default/vendor/otherproject/.private_lib.objs/cctx.ocaml-index
  ./_build/default/vendor/otherproject/.vendored_lib.objs/cctx.ocaml-index

  $ ocaml-uideps dump ./_build/default/project.ocaml-index
  15 uids:
  {uid: Dune__exe__Othermod.0; locs:
     "y": File "$TESTCASE_ROOT/othermod.ml", line 1, characters 4-5;
     "y": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 17-18
   uid: Dune__exe__Othermod; locs:
     "Dune__exe__Othermod": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 7, characters 18-37;
     "Othermod": File "$TESTCASE_ROOT/main.ml", line 1, characters 10-18
   uid: Otherlib.1; locs:
     "do_something": File "$TESTCASE_ROOT/lib/otherlib.ml", line 2, characters 4-16
   uid: Dune__exe__Othermod.1; locs:
     "other": File "$TESTCASE_ROOT/main.ml", line 1, characters 20-25;
     "other": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 4-9
   uid: Imp_lib.0; locs:
     "imp_x": File "$TESTCASE_ROOT/implicit-lib/imp_lib.ml", line 1, characters 4-9;
     "Otherlib.imp_x": File "$TESTCASE_ROOT/main.ml", line 1, characters 52-66
   uid: Imp_lib; locs:
     "Imp_lib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 4, characters 8-15
   uid: Otherlib.0; locs:
     "fromotherlib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 1, characters 4-16;
     "fromotherlib": File "$TESTCASE_ROOT/lib/otherlib.ml", line 2, characters 29-41;
     "Otherlib.fromotherlib": File "$TESTCASE_ROOT/main.ml", line 1, characters 28-49
   uid: Private_lib.0; locs:
     "more": File "$TESTCASE_ROOT/vendor/otherproject/private_lib.ml", line 1, characters 4-8
   uid: Stdlib.313; locs:
     "print_int": File "$TESTCASE_ROOT/main.ml", line 1, characters 0-9;
     "print_int": File "$TESTCASE_ROOT/main.ml", line 2, characters 0-9
   uid: Vendored_lib.0; locs:
     "Vendored_lib.value": File "$TESTCASE_ROOT/main.ml", line 2, characters 10-28;
     "value": File "$TESTCASE_ROOT/vendor/otherproject/vendored_lib.ml", line 1, characters 4-9
   uid: Stdlib.55; locs:
     "+": File "$TESTCASE_ROOT/main.ml", line 1, characters 26-27;
     "+": File "$TESTCASE_ROOT/main.ml", line 1, characters 50-51;
     "+": File "$TESTCASE_ROOT/othermod.ml", line 2, characters 15-16
   uid: Stdlib.141; locs:
     "ignore": File "$TESTCASE_ROOT/lib/otherlib.ml", line 2, characters 22-28
   uid: Dune__exe.0; locs:
     "Main": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 4, characters 7-11
   uid: Dune__exe.1; locs:
     "Othermod": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 7, characters 7-15
   uid: Dune__exe__Main; locs:
     "Dune__exe__Main": File "$TESTCASE_ROOT/.main.eobjs/dune__exe.ml-gen", line 4, characters 14-29
   }, 0 approx shapes: {}, and shapes for CUS .
