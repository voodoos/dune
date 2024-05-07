  $ cat >dune-project <<EOF
  > (lang dune 3.12)
  > EOF

  $ cat >dune <<EOF
  > (include_subdirs qualified)
  > (library
  >  (name foo))
  > EOF

  $ touch main.ml
  $ mkdir utils
  $ touch utils/calc.ml

  $ mkdir groupintf
  $ touch groupintf/groupintf.ml
  $ touch groupintf/calc.ml

  $ opam_prefix="$(ocamlc -where)"
  $ export BUILD_PATH_PREFIX_MAP="/OPAM_PREFIX=$opam_prefix:$BUILD_PATH_PREFIX_MAP"

  $ dune build .merlin-conf/lib-foo
  $ dune ocaml merlin dump-config .
  Foo: _build/default/foo
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Foo: _build/default/foo.ml-gen
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo))
  Foo__Groupintf__: _build/default/foo__Groupintf__
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Foo__Groupintf__: _build/default/foo__Groupintf__.ml-gen
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Groupintf__))
  Utils: _build/default/foo__Utils
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Utils: _build/default/foo__Utils.ml-gen
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Utils))
  Calc: _build/default/groupintf/calc
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Groupintf__ -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Calc: _build/default/groupintf/calc.ml
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Groupintf__ -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Groupintf__Calc))
  Groupintf: _build/default/groupintf/groupintf
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Groupintf__ -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Groupintf: _build/default/groupintf/groupintf.ml
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Groupintf__ -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Groupintf))
  Main: _build/default/main
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Main: _build/default/main.ml
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Main))
  Calc: _build/default/utils/calc
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Utils -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g)))
  Calc: _build/default/utils/calc.ml
  ((STDLIB /OPAM_PREFIX)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/groupintf)
   (S
    $TESTCASE_ROOT/utils)
   (FLG (-open Foo__Utils -open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62@67@69-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Utils__Calc))
  $ dune ocaml merlin dump-config utils
