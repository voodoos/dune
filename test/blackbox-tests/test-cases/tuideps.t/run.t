
  $ dune exec ./main.exe
  42

  $ dune build @check
  $ find . -name '*.uideps'
  ./_build/default/.main.eobjs/cctx.uideps
  ./_build/default/lib/.otherlib.objs/cctx.uideps
  ./_build/default/project.uideps

  $ ocaml-uideps dump _build/default/.main.eobjs/cctx.uideps
  {uid: Dune__exe__Othermod.0; locs: File "othermod.ml", line 1, characters 4-5;
                                     File "othermod.ml", line 2, characters 17-18
   uid: Dune__exe__Othermod; locs: File ".main.eobjs/dune__exe.ml-gen", line 6, characters 18-37;
                                   File "main.ml", line 1, characters 10-18
   uid: Stdlib.56; locs: File "othermod.ml", line 2, characters 15-16
   uid: Dune__exe__Othermod.1; locs: File "main.ml", line 1, characters 20-25;
                                     File "othermod.ml", line 2, characters 4-9
   uid: Otherlib.0; locs: File "main.ml", line 1, characters 28-49
   uid: Stdlib.313; locs: File "main.ml", line 1, characters 0-9
   uid: Stdlib.55; locs: File "main.ml", line 1, characters 26-27
   uid: Dune__exe.1; locs: File ".main.eobjs/dune__exe.ml-gen", line 6, characters 0-37
   uid: Dune__exe.0; locs: File ".main.eobjs/dune__exe.ml-gen", line 2, characters 0-29
   uid: Dune__exe__Main; locs: File ".main.eobjs/dune__exe.ml-gen", line 2, characters 14-29
   }

  $ ocaml-uideps dump ./_build/default/lib/.otherlib.objs/cctx.uideps
  {uid: Otherlib.1; locs: File "lib/otherlib.ml", line 2, characters 4-16
   uid: Otherlib.0; locs: File "lib/otherlib.ml", line 1, characters 4-16;
                          File "lib/otherlib.ml", line 2, characters 29-41
   uid: Stdlib.141; locs: File "lib/otherlib.ml", line 2, characters 22-28}

  $ ocaml-uideps dump ./_build/default/project.uideps
  {uid: Dune__exe__Othermod.0; locs: File "othermod.ml", line 1, characters 4-5;
                                     File "othermod.ml", line 2, characters 17-18
   uid: Dune__exe__Othermod; locs: File ".main.eobjs/dune__exe.ml-gen", line 6, characters 18-37;
                                   File "main.ml", line 1, characters 10-18
   uid: Stdlib.56; locs: File "othermod.ml", line 2, characters 15-16
   uid: Otherlib.1; locs: File "lib/otherlib.ml", line 2, characters 4-16
   uid: Dune__exe__Othermod.1; locs: File "main.ml", line 1, characters 20-25;
                                     File "othermod.ml", line 2, characters 4-9
   uid: Otherlib.0; locs: File "lib/otherlib.ml", line 1, characters 4-16;
                          File "lib/otherlib.ml", line 2, characters 29-41;
                          File "main.ml", line 1, characters 28-49
   uid: Stdlib.313; locs: File "main.ml", line 1, characters 0-9
   uid: Stdlib.55; locs: File "main.ml", line 1, characters 26-27
   uid: Stdlib.141; locs: File "lib/otherlib.ml", line 2, characters 22-28
   uid: Dune__exe.0; locs: File ".main.eobjs/dune__exe.ml-gen", line 2, characters 0-29
   uid: Dune__exe.1; locs: File ".main.eobjs/dune__exe.ml-gen", line 6, characters 0-37
   uid: Dune__exe__Main; locs: File ".main.eobjs/dune__exe.ml-gen", line 2, characters 14-29
   }
