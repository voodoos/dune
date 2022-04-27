  $ dune exec ./stubs_exe.exe
  Byte (0) or native (1) ? 1

  $ dune exec ./stubs_exe.bc.exe
  Byte (0) or native (1) ? 1

  $ dune exec --verbose ./stubs_lib.exe
  Shared cache: disabled
  Workspace root:
  $TESTCASE_ROOT
  Running[0]: /Users/ulysse/.opam/4.13.1/bin/ocamlc.opt -config > /var/folders/w6/k6g9gfrj59lf_3ymz3312tcc0000gn/T/build_6a8a1e_dune/dune_c142bd_output
  Dune context:
   { name = "default"
   ; kind = "default"
   ; profile = Dev
   ; merlin = true
   ; for_host = None
   ; fdo_target_exe = None
   ; build_dir = "default"
   ; toplevel_path = Some External "/Users/ulysse/.opam/4.13.1/lib/toplevel"
   ; ocaml_bin = External "/Users/ulysse/.opam/4.13.1/bin"
   ; ocaml = Ok External "/Users/ulysse/.opam/4.13.1/bin/ocaml"
   ; ocamlc = External "/Users/ulysse/.opam/4.13.1/bin/ocamlc.opt"
   ; ocamlopt = Ok External "/Users/ulysse/.opam/4.13.1/bin/ocamlopt.opt"
   ; ocamldep = Ok External "/Users/ulysse/.opam/4.13.1/bin/ocamldep.opt"
   ; ocamlmklib = Ok External "/Users/ulysse/.opam/4.13.1/bin/ocamlmklib.opt"
   ; env = map {}
   ; findlib_path =
       [ External "/Users/ulysse/tmp/dune-foreign/_build/install/default/lib"
       ; External "/Users/ulysse/.opam/4.13.1/lib"
       ]
   ; arch_sixtyfour = true
   ; natdynlink_supported = true
   ; supports_shared_libraries = true
   ; ocaml_config =
       { version = "4.13.1"
       ; standard_library_default = "/Users/ulysse/.opam/4.13.1/lib/ocaml"
       ; standard_library = "/Users/ulysse/.opam/4.13.1/lib/ocaml"
       ; standard_runtime = "the_standard_runtime_variable_was_deleted"
       ; ccomp_type = "cc"
       ; c_compiler = "cc"
       ; ocamlc_cflags =
           [ "-O2"; "-fno-strict-aliasing"; "-fwrapv"; "-pthread" ]
       ; ocamlc_cppflags = [ "-D_FILE_OFFSET_BITS=64" ]
       ; ocamlopt_cflags =
           [ "-O2"; "-fno-strict-aliasing"; "-fwrapv"; "-pthread" ]
       ; ocamlopt_cppflags = [ "-D_FILE_OFFSET_BITS=64" ]
       ; bytecomp_c_compiler =
           [ "cc"
           ; "-O2"
           ; "-fno-strict-aliasing"
           ; "-fwrapv"
           ; "-pthread"
           ; "-D_FILE_OFFSET_BITS=64"
           ]
       ; bytecomp_c_libraries = [ "-lm"; "-lpthread" ]
       ; native_c_compiler =
           [ "cc"
           ; "-O2"
           ; "-fno-strict-aliasing"
           ; "-fwrapv"
           ; "-pthread"
           ; "-D_FILE_OFFSET_BITS=64"
           ]
       ; native_c_libraries = [ "-lm" ]
       ; native_pack_linker = [ "ld"; "-r"; "-o" ]
       ; cc_profile = []
       ; architecture = "amd64"
       ; model = "default"
       ; int_size = 63
       ; word_size = 64
       ; system = "macosx"
       ; asm = [ "cc"; "-c"; "-Wno-trigraphs" ]
       ; asm_cfi_supported = true
       ; with_frame_pointers = false
       ; ext_exe = ""
       ; ext_obj = ".o"
       ; ext_asm = ".s"
       ; ext_lib = ".a"
       ; ext_dll = ".so"
       ; os_type = "Unix"
       ; default_executable_name = "a.out"
       ; systhread_supported = true
       ; host = "x86_64-apple-darwin20.6.0"
       ; target = "x86_64-apple-darwin20.6.0"
       ; profiling = false
       ; flambda = false
       ; spacetime = false
       ; safe_string = true
       ; exec_magic_number = "Caml1999X030"
       ; cmi_magic_number = "Caml1999I030"
       ; cmo_magic_number = "Caml1999O030"
       ; cma_magic_number = "Caml1999A030"
       ; cmx_magic_number = "Caml1999Y030"
       ; cmxa_magic_number = "Caml1999Z030"
       ; ast_impl_magic_number = "Caml1999M030"
       ; ast_intf_magic_number = "Caml1999N030"
       ; cmxs_magic_number = "Caml1999D030"
       ; cmt_magic_number = "Caml1999T030"
       ; natdynlink_supported = true
       ; supports_shared_libraries = true
       ; windows_unicode = false
       }
   }
  Running[1]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -bin-annot -I lib/.lib_with_md_stubs.objs/byte -no-alias-deps -opaque -o lib/.lib_with_md_stubs.objs/byte/lib_with_md_stubs.cmo -c -impl lib/lib_with_md_stubs.ml)
  Running[2]: (cd _build/default/lib && /usr/bin/cc -O2 -fno-strict-aliasing -fwrapv -pthread -D_FILE_OFFSET_BITS=64 -DNATIVE_CODE -g -I /Users/ulysse/.opam/4.13.1/lib/ocaml -o c_stubs_lib_native.o -c c_stubs_lib.c)
  Running[3]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -bin-annot -I .stubs_lib.eobjs/byte -I lib/.lib_with_md_stubs.objs/byte -no-alias-deps -opaque -o .stubs_lib.eobjs/byte/dune__exe__Stubs_lib.cmi -c -intf stubs_lib.mli)
  Running[4]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -I lib/.lib_with_md_stubs.objs/byte -I lib/.lib_with_md_stubs.objs/native -intf-suffix .ml -no-alias-deps -opaque -o lib/.lib_with_md_stubs.objs/native/lib_with_md_stubs.cmx -c -impl lib/lib_with_md_stubs.ml)
  Running[5]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlmklib.opt -g -o lib/lib_with_md_stubs_stubs_native lib/c_stubs_lib_native.o)
  Running[6]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -I .stubs_lib.eobjs/byte -I .stubs_lib.eobjs/native -I lib/.lib_with_md_stubs.objs/byte -I lib/.lib_with_md_stubs.objs/native -intf-suffix .ml -no-alias-deps -opaque -o .stubs_lib.eobjs/native/dune__exe__Stubs_lib.cmx -c -impl stubs_lib.ml)
  Running[7]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -a -o lib/lib_with_md_stubs.cmxa -cclib -llib_with_md_stubs_stubs_native lib/.lib_with_md_stubs.objs/native/lib_with_md_stubs.cmx)
  Running[8]: (cd _build/default && /Users/ulysse/.opam/4.13.1/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -o stubs_lib.exe lib/lib_with_md_stubs.cmxa -I lib .stubs_lib.eobjs/native/dune__exe__Stubs_lib.cmx)
  Byte (0) or native (1) ? 42

  $ dune exec ./stubs_lib.bc.exe
  Byte (0) or native (1) ? 0

  $ tree -a _build
  _build
  |-- .db
  |-- .digest-db
  |-- .filesystem-clock
  |-- default
  |   |-- .dune
  |   |   |-- configurator
  |   |   `-- configurator.v2
  |   |-- .merlin-conf
  |   |   |-- exe-stubs_exe
  |   |   `-- exe-stubs_lib
  |   |-- .stubs_exe.eobjs
  |   |   |-- byte
  |   |   |   |-- dune__exe__Stubs_exe.cmi
  |   |   |   |-- dune__exe__Stubs_exe.cmo
  |   |   |   |-- dune__exe__Stubs_exe.cmt
  |   |   |   `-- dune__exe__Stubs_exe.cmti
  |   |   `-- native
  |   |       |-- dune__exe__Stubs_exe.cmx
  |   |       `-- dune__exe__Stubs_exe.o
  |   |-- .stubs_lib.eobjs
  |   |   |-- byte
  |   |   |   |-- dune__exe__Stubs_lib.cmi
  |   |   |   |-- dune__exe__Stubs_lib.cmo
  |   |   |   |-- dune__exe__Stubs_lib.cmt
  |   |   |   `-- dune__exe__Stubs_lib.cmti
  |   |   `-- native
  |   |       |-- dune__exe__Stubs_lib.cmx
  |   |       `-- dune__exe__Stubs_lib.o
  |   |-- c_stubs.c
  |   |-- c_stubs.o
  |   |-- c_stubs_native.o
  |   |-- lib
  |   |   |-- .lib_with_md_stubs.objs
  |   |   |   |-- byte
  |   |   |   |   |-- lib_with_md_stubs.cmi
  |   |   |   |   |-- lib_with_md_stubs.cmo
  |   |   |   |   `-- lib_with_md_stubs.cmt
  |   |   |   `-- native
  |   |   |       |-- lib_with_md_stubs.cmx
  |   |   |       `-- lib_with_md_stubs.o
  |   |   |-- .merlin-conf
  |   |   |   `-- lib-lib_with_md_stubs
  |   |   |-- c_stubs_lib.c
  |   |   |-- c_stubs_lib.o
  |   |   |-- c_stubs_lib_native.o
  |   |   |-- dlllib_with_md_stubs_stubs.so
  |   |   |-- dlllib_with_md_stubs_stubs_native.so
  |   |   |-- lib_with_md_stubs.a
  |   |   |-- lib_with_md_stubs.cma
  |   |   |-- lib_with_md_stubs.cmxa
  |   |   |-- lib_with_md_stubs.ml
  |   |   |-- liblib_with_md_stubs_stubs.a
  |   |   `-- liblib_with_md_stubs_stubs_native.a
  |   |-- stubs_exe.bc.exe
  |   |-- stubs_exe.exe
  |   |-- stubs_exe.ml
  |   |-- stubs_exe.mli
  |   |-- stubs_lib.bc.exe
  |   |-- stubs_lib.exe
  |   |-- stubs_lib.ml
  |   `-- stubs_lib.mli
  `-- log
  
  14 directories, 48 files
