We build the project
  $ dune exec ./test.exe
  bar

Verify that merlin configuration was generated
  $ dune ocaml-merlin --dump-config=$(pwd)
  test
  ((EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (B
    $TESTCASE_ROOT/_build/default/.test.eobjs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/411)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs)))
  foo
  ((EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.foo.objs/byte)
   (S
    $TESTCASE_ROOT)
   (S
    $TESTCASE_ROOT/411)
   (FLG
    (-w
     @1..3@5..28@30..39@43@46..47@49..57@61..62-40
     -strict-sequence
     -strict-formats
     -short-paths
     -keep-locs)))

Nut not in the sub-folder whose content was copied
  $ dune ocaml-merlin --dump-config=$(pwd)/411

No we check that both querying from the root and the subfolder works
  $ FILE=$(pwd)/foo.ml
  $ FILE411=$(pwd)/411/test.ml

  $ dune ocaml-merlin  <<EOF
  > (4:File${#FILE}:$FILE)
  > EOF
  ((17:EXCLUDE_QUERY_DIR)(1:B168:$TESTCASE_ROOT/_build/default/.foo.objs/byte)(1:S138:$TESTCASE_ROOT)(1:S142:$TESTCASE_ROOT/411)(3:FLG(2:-w45:@1..3@5..28@30..39@43@46..47@49..57@61..62-4016:-strict-sequence15:-strict-formats12:-short-paths10:-keep-locs)))

  $ dune ocaml-merlin  <<EOF
  > (4:File${#FILE411}:$FILE411)
  > EOF
  ((17:EXCLUDE_QUERY_DIR)(1:B168:$TESTCASE_ROOT/_build/default/.foo.objs/byte)(1:B170:$TESTCASE_ROOT/_build/default/.test.eobjs/byte)(1:S138:$TESTCASE_ROOT)(1:S142:$TESTCASE_ROOT/411)(3:FLG(2:-w45:@1..3@5..28@30..39@43@46..47@49..57@61..62-4016:-strict-sequence15:-strict-formats12:-short-paths10:-keep-locs)))
