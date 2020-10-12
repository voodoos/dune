  $ dune build @install

  $ dune install --prefix _install
  Installing _install/lib/pak/META
  Installing _install/lib/pak/dune-package
  Installing _install/lib/pak/opam
  Installing _install/bin/main

  $ _build/install/default/bin/main
  None

  $ _install/bin/main
  Some custom information accessible with `My_cbi.custom`


--debug-dep

#  $ dune rules --rec .main.eobjs/native/my_cbi.cmx
#  $ dune rules _build/default/.main.eobjs/byte/my_cbi.cmo
#  $ dune rules _build/default/.main.eobjs/byte/dune__exe__My_cbi.cmo
