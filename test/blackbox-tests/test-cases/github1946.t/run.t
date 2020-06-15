This test demonstrates that -ppx is missing when two stanzas are in the same
dune file, but require different ppx specifications

  $ dune build @all --profile release
  $ cat _build/default/.merlin-conf |
  > sed 's/[0-9]*:/?:/g' | sed 's/)(/)|(/g' | tr '|' '\n' | grep -E "FLG"
  (?:FLG(?:-open?:Usesppx?:-w?:-?:-open?:Usesppx?:-w?:-40)))
