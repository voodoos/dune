copy_files would break the generation of the preprocessing flags
  $ dune build copy_files/.merlin-conf
  $ cat _build/default/copy_files/.merlin-conf |
  > sed 's/[0-9]*:/?:/g' | sed 's/)/)|/g' | tr '|' '\n' | grep -E "pp"
  (?:FLG(?:-pp?:$TESTCASE_ROOT/_build/default/pp.exe)
