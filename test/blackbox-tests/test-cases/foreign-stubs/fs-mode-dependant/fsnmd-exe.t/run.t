  $ opam_prefix="$(opam var prefix)"
  $ export BUILD_PATH_PREFIX_MAP=\
  > "/OPAM_PREFIX=$opam_prefix:$BUILD_PATH_PREFIX_MAP"

  $ dune build ./stubs_exe.exe

Here the stubs are the same for byte and native mode, so there should be only
one object (.o) file
  $ ls _build/default/c_stubs*
  _build/default/c_stubs.c
  _build/default/c_stubs.o

$ dune clean
$ dune rules @all
