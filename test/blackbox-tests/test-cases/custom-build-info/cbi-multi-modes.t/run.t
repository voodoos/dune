  $ dune build @install --debug-dep


  $ dune install --prefix _install
  Installing _install/lib/pak/META
  Installing _install/lib/pak/dune-package
  Installing _install/lib/pak/opam
  Installing _install/bin/main
  Installing _install/bin/main-bc

  $ _build/install/default/bin/main
  None
  None

  $ _install/bin/main
  Some custom information accessible with `My_cbi.custom`
  Some custom information accessible with `My_cbi_exe.custom`

  $ ocamlrun _install/bin/main-bc
  Some custom information accessible with `My_cbi.custom`
  Some custom information accessible with `My_cbi_exe.custom`
