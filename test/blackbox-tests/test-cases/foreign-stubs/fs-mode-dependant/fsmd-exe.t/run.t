  $ opam_prefix="$(opam var prefix)"
  $ export BUILD_PATH_PREFIX_MAP=\
  > "/OPAM_PREFIX=$opam_prefix:$BUILD_PATH_PREFIX_MAP"

  $ dune build stubs_exe.exe --display=verbose 2>&1 | grep "Running\[[^0]"
  Running[1]: (cd _build/default && /OPAM_PREFIX/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -bin-annot -I .stubs_exe.eobjs/byte -no-alias-deps -opaque -o .stubs_exe.eobjs/byte/dune__exe__Stubs_exe.cmi -c -intf stubs_exe.mli)
  Running[2]: (cd _build/default && /usr/bin/cc -O2 -fno-strict-aliasing -fwrapv -D_FILE_OFFSET_BITS=64 -D_REENTRANT -O2 -fno-strict-aliasing -fwrapv -DNATIVE_CODE -g -I /OPAM_PREFIX/lib/ocaml -o c_stubs.o -c c_stubs.c)
  Running[3]: (cd _build/default && /OPAM_PREFIX/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -I .stubs_exe.eobjs/byte -I .stubs_exe.eobjs/native -intf-suffix .ml -no-alias-deps -opaque -o .stubs_exe.eobjs/native/dune__exe__Stubs_exe.cmx -c -impl stubs_exe.ml)
  Running[4]: (cd _build/default && /OPAM_PREFIX/bin/ocamlopt.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -o stubs_exe.exe c_stubs.o .stubs_exe.eobjs/native/dune__exe__Stubs_exe.cmx)

When building native executable, the output should be: 
# Running[]: Byte (0) or native (1) ? 1
  $ dune exec ./stubs_exe.exe 
  Running[]: Byte (0) or native (1) ? 1

  $ dune clean
  $ dune build stubs_exe.bc.exe --display=verbose 2>&1 | grep "Running\[[^0]"
  Running[1]: (cd _build/default && /OPAM_PREFIX/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -bin-annot -I .stubs_exe.eobjs/byte -no-alias-deps -opaque -o .stubs_exe.eobjs/byte/dune__exe__Stubs_exe.cmi -c -intf stubs_exe.mli)
  Running[2]: (cd _build/default && /usr/bin/cc -O2 -fno-strict-aliasing -fwrapv -D_FILE_OFFSET_BITS=64 -D_REENTRANT -O2 -fno-strict-aliasing -fwrapv -g -I /OPAM_PREFIX/lib/ocaml -o c_stubs_byte.o -c c_stubs.c)
  Running[3]: (cd _build/default && /OPAM_PREFIX/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -bin-annot -I .stubs_exe.eobjs/byte -intf-suffix .ml -no-alias-deps -opaque -o .stubs_exe.eobjs/byte/dune__exe__Stubs_exe.cmo -c -impl stubs_exe.ml)
  Running[4]: (cd _build/default && /OPAM_PREFIX/bin/ocamlc.opt -w @1..3@5..28@30..39@43@46..47@49..57@61..62-40 -strict-sequence -strict-formats -short-paths -keep-locs -g -o stubs_exe.bc.exe -output-complete-exe c_stubs_byte.o .stubs_exe.eobjs/byte/dune__exe__Stubs_exe.cmo)

When building bytecode executable, the output should be: 
# Running[]: Byte (0) or native (1) ? 0
  $ dune exec ./stubs_exe.bc.exe 
  Running[]: Byte (0) or native (1) ? 0
