(** This module contains a small database of flags that is used when compiling C
    and C++ stubs. Indeed, both the C++ flags and the output arguments can
    differ from one compiler to another. *)

(** [default_with_output_args ~kind ctx destination] returns both the list of
    default flags to compile C and C++ stubs and the correct output arguments
    depending on the default C compiler:

    - For CXX the default flags will depend on the detected compiler
    - For C the flags are the ones from [ocamlc -config]

    The returned flag list also include the feedback-directed optimizations
    flags (FDO). *)
val default_with_output_args :
     kind:Dune_engine.Foreign_language.t
  -> Context.t
  -> Stdune.Path.Build.w Stdune.Path.Local_gen.t
  -> Command.Args.dynamic Command.Args.t * Command.Args.dynamic Command.Args.t
