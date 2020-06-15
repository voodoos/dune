  $ dune build @print-merlins --profile release
  sanitize_dot_merlin alias print-merlins
  # Processing exe/.merlin-conf
  ((?:EXCLUDE_QUERY_DIR)
  (?:B?:$LIB_PREFIX/lib/bytes)
  (?:B?:$LIB_PREFIX/lib/findlib)
  (?:B?:$LIB_PREFIX/lib/ocaml)
  (?:B?:$TESTCASE_ROOT/_build/default/exe/.x.eobjs/byte)
  (?:B?:$LIB_PREFIX/lib/.foo.objs/public_cmi)
  (?:S?:$LIB_PREFIX/lib/bytes)
  (?:S?:$LIB_PREFIX/lib/findlib)
  (?:S?:$LIB_PREFIX/lib/ocaml)
  (?:S?:$TESTCASE_ROOT/exe)
  (?:S?:$LIB_PREFIX/lib)
  (?:FLG(?:-pp?:$TESTCASE_ROOT/_build/default/pp/pp.exe))
  (?:FLG(?:-w?:-40)))
  # Processing lib/.merlin-conf
  ((?:EXCLUDE_QUERY_DIR)
  (?:B?:$LIB_PREFIX/lib/bytes)
  (?:B?:$LIB_PREFIX/lib/findlib)
  (?:B?:$LIB_PREFIX/lib/ocaml)
  (?:B?:$LIB_PREFIX/lib/.bar.objs/byte)
  (?:B?:$LIB_PREFIX/lib/.foo.objs/byte)
  (?:S?:$LIB_PREFIX/lib/bytes)
  (?:S?:$LIB_PREFIX/lib/findlib)
  (?:S?:$LIB_PREFIX/lib/ocaml)
  (?:S?:$LIB_PREFIX/lib)
  (?:S?:$LIB_PREFIX/lib/subdir)
  (?:FLG(?:-ppx?:$TESTCASE_ROOT/_build/default/.ppx/4128e43a9cfb141a37f547484cc9bf46/ppx.exe --as-ppx --cookie 'library-name="foo"'))
  (?:FLG(?:-open?:Foo?:-w?:-?:-open?:Bar?:-w?:-40)))

Make sure a ppx directive is generated

  $ grep -q ppx _build/default/lib/.merlin-conf

Make sure pp flag is correct and variables are expanded

  $ dune build @print-merlins-pp
  sanitize_dot_merlin alias print-merlins-pp
  # Processing pp-with-expand/.merlin-conf
  ((?:EXCLUDE_QUERY_DIR)
  (?:B?:$TESTCASE_ROOT/_build/default/pp-with-expand/.foobar.eobjs/byte)
  (?:S?:$TESTCASE_ROOT/pp-with-expand)
  (?:FLG(?:-pp?:$TESTCASE_ROOT/_build/default/pp/pp.exe -nothing))
  (?:FLG(?:-w?:@1..3@5..28@30..39@43@46..47@49..57@61..62-?:-strict-sequence?:-strict-formats?:-short-paths?:-keep-locs)))

We want future-syntax to either be applied, or not, depending on OCaml version.
Adding the `echo` with expected output to the set of lines is a way of achieving that.

TODO fix this test: it is not easy to test the future-syntax anymore...

$ (echo "(?:FLG-?:-pp '\$BIN/ocaml-syntax-shims'"; dune build @print-merlins-future-syntax 2>&1) | sort | uniq

# Processing future-syntax/.merlin-conf
((?:EXCLUDE_QUERY_DIR)
(?:B?:$TESTCASE_ROOT/_build/default/future-syntax/.pp_future_syntax.eobjs/byte)
(?:FLG-?:-pp '$BIN/ocaml-syntax-shims'
(?:FLG?:-w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs)
(?:S?:$TESTCASE_ROOT/future-syntax)
)
sanitize_dot_merlin alias print-merlins-future-syntax
