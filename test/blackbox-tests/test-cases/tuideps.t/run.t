
  $ dune exec ./main.exe
  42
$ tree -a

  $ dune build _build/default/.main.eobjs/byte/dune__exe__Main.uideps

  $ ocaml-uideps dump _build/default/.main.eobjs/byte/dune__exe__Main.uideps
  {uid: Stdlib.313; locs: File "main.ml", line 1, characters 0-9
   uid: Otherlib.0; locs: File "main.ml", line 1, characters 28-49
   uid: Dune__exe__Othermod; locs: File "main.ml", line 1, characters 10-18
   uid: Stdlib.55; locs: File "main.ml", line 1, characters 26-27
   uid: Dune__exe__Othermod.1; locs: File "main.ml", line 1, characters 20-25}

  $ ls _build/default/.main.eobjs/byte/
  dune__exe.cmi
  dune__exe.cmo
  dune__exe.cmt
  dune__exe__Main.cmi
  dune__exe__Main.cmo
  dune__exe__Main.cmt
  dune__exe__Main.cmti
  dune__exe__Main.uideps
  dune__exe__Othermod.cmi
  dune__exe__Othermod.cmo
  dune__exe__Othermod.cmt


  $ dune build _build/default/unit.uideps
  $ ocaml-uideps dump _build/default/unit.uideps
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
  
  $ dune build _build/default/lib/unit.uideps

  $ dune build _build/default/context.uideps
  $ ocaml-uideps dump _build/default/context.uideps

  $ tree -a _build/default
