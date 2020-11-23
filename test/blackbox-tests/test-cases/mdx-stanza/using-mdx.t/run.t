  $ cat >dune-project <<EOF
  > (lang dune 2.4)
  > EOF

To use the mdx stanza you need to explicitly set (using mdx ..) in the
dune-project

  $ dune build @install
  Info: Appending this line to dune-project: (using mdx 0.1)
