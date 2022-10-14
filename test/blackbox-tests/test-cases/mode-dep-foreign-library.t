  $ cat > dune-project <<EOF
  > (lang dune 3.5)
  > (using mode_specific_stubs 0.1)
  > EOF

  $ cat >config.cpp <<EOF
  > #include <caml/mlvalues.h>
  > extern "C" value config(value unit) { return Val_int(CONFIG_VALUE); }
  > EOF

  $ cat >main.ml <<EOF
  > external config : unit -> int = "config"
  > let () = Printf.printf "%d" @@ config ()
  > EOF

  $ cat >dune <<EOF
  > (foreign_library
  >  (archive_name config)
  >  (language cxx)
  >  (mode native)
  >  (flags -DCONFIG_VALUE=2009)
  >  (names config))
  > 
  > (foreign_library
  >  (archive_name config)
  >  (language cxx)
  >  (mode byte)
  >  (flags -DCONFIG_VALUE=2009)
  >  (names config))
  > 
  > 
  > (executable
  >  (name main)
  >  (modes exe byte_complete)
  >  (foreign_archives config)
  >  (modules main))
  > EOF

  $ rm -rf _build
  $ dune build

  $ dune rules ./main.exe
  2009

  $ dune exec  ./main.bc.exe
  2009
