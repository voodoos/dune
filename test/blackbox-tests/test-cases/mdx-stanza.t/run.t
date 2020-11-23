  $ cat >using-mdx/dune-project <<EOF
  > (lang dune 2.4)
  > EOF

To use the mdx stanza you need to explicitly set (using mdx ..) in the
dune-project

  $ dune build @install --root using-mdx/
  Entering directory 'using-mdx'
  Info: Appending this line to dune-project: (using mdx 0.1)

It also requires dune lang 2.4 or higher

  $ dune build @install --root lang-version/
  Entering directory 'lang-version'
  File "dune-project", line 3, characters 11-14:
  3 | (using mdx 0.1)
                 ^^^
  Warning: Version 0.1 of mdx extension to verify code blocks in .md files is
  not supported until version 2.4 of the dune language.
  There are no supported versions of this extension in version 2.3 of the dune
  language.
  
  File "dune", line 1, characters 0-5:
  1 | (mdx)
      ^^^^^
  Error: 'mdx' is only available since version 2.4 of the dune language. Please
  update your dune-project file to have (lang dune 2.4).
  [1]

You can use the mdx stanza to check your documentation in markdown and mli files

  $ dune runtest --root simple/
  Entering directory 'simple'
  File "README.md", line 1, characters 0-0:
  Error: Files _build/default/README.md and
  _build/default/.mdx/README.md.corrected differ.
  [1]

Dune should invoke `ocaml-mdx deps` to figure out the files and directories a markdown
or mli to-be-mdxed file depends upon

  $ dune runtest --root mdx-deps/
  Entering directory 'mdx-deps'

You can make local packages available to mdx by using the `packages` field of
the stanza

  $ dune runtest --root local-package
  Entering directory 'local-package'

Dune does not fail if the `packages` are not available at evaluation time
(regression test fixed by ocaml/dune#3650)

  $ cd local-package-unrelated && dune build -p unrelated-package; cd ../

Dune fails if the `packages` are not available at execution time

  $ cd local-package-unrelated && dune runtest -p unrelated-package; cd ../
  File "dune", line 3, characters 11-14:
  3 |  (packages pkg))
                 ^^^
  Error: Package pkg does not exist

You can set MDX preludes using the preludes field of the stanza

  $ dune runtest --root preludes
  Entering directory 'preludes'

Since 0.2 you can use the `libraries` field to have them linked into the test executable

  $ cat >linked-libraries/dune-project <<EOF
  > (lang dune 2.8)
  > (using mdx 0.2)
  > EOF

  $ dune runtest --root linked-libraries
  Entering directory 'linked-libraries'

MDX stanza 0.1 does not support linking libraries

  $ cat >linked-libraries/dune-project <<EOF
  > (lang dune 2.8)
  > (using mdx 0.1)
  > EOF

  $ dune runtest --root linked-libraries
  Entering directory 'linked-libraries'
  File "dune", line 3, characters 1-24:
  3 |  (libraries private_lib))
       ^^^^^^^^^^^^^^^^^^^^^^^
  Error: 'libraries' is only available since version 0.2 of mdx extension to
  verify code blocks in .md files. Please update your dune-project file to have
  (using mdx 0.2).
  [1]

Since version 0.2 the mdx stanza supports a more genereic `deps` field.
A deprecation warning is raised if using the olf `packages` field.

  $ cat >new-deps-field/dune-project <<EOF
  > (lang dune 2.8)
  > (using mdx 0.2)
  > EOF

  $ dune runtest --root new-deps-field
  Entering directory 'new-deps-field'
  File "dune", line 4, characters 1-15:
  4 |  (packages pkg))
       ^^^^^^^^^^^^^^
  Warning: 'packages' was deprecated in version 0.2 of mdx extension to verify
  code blocks in .md files.

But using the new field with the old stanza would fail

  $ cat >new-deps-field/dune-project <<EOF
  > (lang dune 2.8)
  > (using mdx 0.1)
  > EOF

  $ dune runtest --root new-deps-field
  Entering directory 'new-deps-field'
  File "dune", line 3, characters 1-22:
  3 |  (deps (package pkg2))
       ^^^^^^^^^^^^^^^^^^^^^
  Error: 'deps' is only available since version 0.2 of mdx extension to verify
  code blocks in .md files. Please update your dune-project file to have (using
  mdx 0.2).
  [1]
