No-glob install for comparison

  $ cat <<EOF > dune
  > (install (package p) (section lib)
  >  (files foo/bar.h (foo/bar2.h as foo/bar2.h)))
  > EOF

  $ dune build @install
  $ dune install --prefix=_install
  Installing _install/lib/p/META
  Installing _install/lib/p/bar.h
  Installing _install/lib/p/dune-package
  Installing _install/lib/p/foo/bar2
  Installing _install/lib/p/opam

  $ dune uninstall --prefix=_install
  Deleting _install/lib/p/META
  Deleting _install/lib/p/bar.h
  Deleting _install/lib/p/dune-package
  Deleting _install/lib/p/foo/bar2
  Deleting _install/lib/p/opam
  Deleting empty directory _install/lib/p/foo
  Deleting empty directory _install/lib/p

  $ dune clean

With-glob

  $ cat <<EOF > dune
  > (install (package p) (section lib) (files (foo/* as foo/bar.d)))
  > EOF

  $ dune build @install
  $ dune install --prefix=_install
  Installing _install/lib/p/META
  Installing _install/lib/p/dune-package
  Installing _install/lib/p/foo/bar.d/bar.h
  Installing _install/lib/p/foo/bar.d/bar2.h
  Installing _install/lib/p/opam

  $ dune uninstall --prefix=_install
  Deleting _install/lib/p/META
  Deleting _install/lib/p/dune-package
  Deleting _install/lib/p/foo/bar.d/bar.h
  Deleting _install/lib/p/foo/bar.d/bar2.h
  Deleting _install/lib/p/opam
  Deleting empty directory _install/lib/p/foo/bar.d

  $ dune clean

Weird crash

  $ cat <<EOF > dune
  > (install (package p) (section lib) (files foo/* as foo))
  > EOF

  $ dune build @install
