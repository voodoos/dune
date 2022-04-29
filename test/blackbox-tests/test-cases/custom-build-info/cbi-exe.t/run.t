  $ dune build @install --debug-artifact-substitution
  Found placeholder in _build/default/main.exe:
  - placeholder: Custom "N/A",".exe_My_cbi2_cbi.txt-gen","default"
  - replaced by: Custom 1,".exe_My_cbi2_cbi.txt-gen","default"
  Found placeholder in _build/default/main.exe:
  - placeholder: Custom "N/A",".exe_My_cbi_cbi.txt-gen","default"
  - replaced by: Custom 1,".exe_My_cbi_cbi.txt-gen","default"

  $ dune install --prefix _install --debug-artifact-substitution
  Installing _install/lib/pak/META
  Installing _install/lib/pak/dune-package
  Installing _install/lib/pak/opam
  Installing _install/bin/main
  Found placeholder in _build/install/default/bin/main:
  - placeholder: Custom 1,".exe_My_cbi2_cbi.txt-gen","default"
  - evaluates to: "And My_cbi2.custom"
  Found placeholder in _build/install/default/bin/main:
  - placeholder: Custom 1,".exe_My_cbi_cbi.txt-gen","default"
  - evaluates to: "Some custom information accessible with `My_cbi.custom`"

  $ _build/install/default/bin/main
  None
  None

  $ _install/bin/main
  Some custom information accessible with `My_cbi.custom`
  And My_cbi2.custom
