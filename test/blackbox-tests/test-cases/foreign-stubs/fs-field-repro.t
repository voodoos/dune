  $ echo "(lang dune 2.0)" > dune-project

  $ cat >sdune <<'EOF'
  > #!/usr/bin/env bash
  > DUNE_SANDBOX=symlink dune "$@"
  > EOF
  $ chmod +x sdune
  
  $ cat >foo.c <<EOF
  > #include <caml/mlvalues.h>
  > value foo(value unit) { return Val_int(9); }
  > EOF
  
  $ cat >foo.ml <<EOF
  > external f : unit -> int = "foo";;
  > Printf.printf "%i\n" (f ())
  > EOF
  
  $ cat >dune <<EOF
  > (executable
  >  (name foo)
  >  (foreign_stubs (language c) (names foo)))
  > EOF
  
  $ ls

  $ ./sdune exec ./foo.exe

  $ cat >dune <<EOF
  > (library
  >  (name foo)
  >  (foreign_stubs (language c) (names foo)))
  > EOF

  $ ./sdune build --display verbose foo.cmxs

$ ./sdune rules foo.cmxs

  $ tree . -a
