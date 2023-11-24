  $ ocamlc_where="$(ocamlc -where)"
  $ export BUILD_PATH_PREFIX_MAP="/OCAMLC_WHERE=$ocamlc_where:$BUILD_PATH_PREFIX_MAP"

  $ dune exec ./foo.exe
  42

  $ dune ocaml merlin dump-config $PWD
  Foo
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OCAMLC_WHERE)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.eobjs/byte)
   (B
    $TESTCASE_ROOT/_build/default/foo/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/foo)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME dune__exe__Foo))

  $ dune ocaml merlin dump-config $PWD/foo
  Bar
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OCAMLC_WHERE)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/foo/.foo.objs/byte)
   (S
    $TESTCASE_ROOT/foo)
   (FLG (-open Foo))
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo__Bar))
  Foo
  ((INDEX_FILE
    $TESTCASE_ROOT/_build/default/project.ocaml-index)
   (STDLIB /OCAMLC_WHERE)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/foo/.foo.objs/byte)
   (S
    $TESTCASE_ROOT/foo)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs
     -g))
   (UNIT_NAME foo))

FIXME : module Foo is not unbound
This test is disabled because it depends on root detection and is not reproducible.
$ ocamlmerlin single errors -filename foo.ml < foo.ml | jq ".value.message"
"Unbound module Foo"
