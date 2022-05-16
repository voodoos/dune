  $ cd sub-project 

This test illustrates an issue that happens when dune is called from a
sub-project of a workspace. The workspace index is not created in that case.
To correctly test that we need to manually tell the root to dune, but that's 
not required when outside of the testsuite.
  $ dune build --workspace=../dune-workspace --root=.. @sub-project/default
  Entering directory '..'
  Leaving directory '..'
  $ cd ..

  $ find . -name '*.cmt*'
  ./_build/install/default/lib/subprojectlib/subprojectlib.cmt
  ./_build/default/sub-project2/lib/.subprojectlib2.objs/byte/subprojectlib2.cmt
  ./_build/default/sub-project/bin/.main.eobjs/byte/dune__exe__Main.cmti
  ./_build/default/sub-project/bin/.main.eobjs/byte/dune__exe__Main.cmt
  ./_build/default/sub-project/lib/.subprojectlib.objs/byte/subprojectlib.cmt

We could expect to have a workspace index in ./_build/default/project.ocaml-index
  $ find . -name 'project.ocaml-index'
  ./_build/default/sub-project/project.ocaml-index

Building from the project workspace does create the global index
  $ dune build @default
  $ find . -name 'project.ocaml-index'
  ./_build/default/sub-project2/project.ocaml-index
  ./_build/default/sub-project/project.ocaml-index
  ./_build/default/project.ocaml-index
