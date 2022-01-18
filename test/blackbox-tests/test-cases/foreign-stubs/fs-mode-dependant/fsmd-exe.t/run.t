  $ dune exec ./stubs_exe.exe
  File "dune", line 6, characters 11-18:
  6 |     (names c_stubs))
                 ^^^^^^^
  Error: Multiple sources map to the same object name "c_stubs":
  - c_stubs.c
  - c_stubs.c
  This is not allowed; please rename them or remove "c_stubs" from object
  names.
  Hint: You can also avoid the name clash by placing the objects into different
  foreign archives and building them in different directories. Foreign archives
  can be defined using the (foreign_library ...) stanza.
  [1]
