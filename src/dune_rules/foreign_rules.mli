open! Dune_engine
open! Stdune
open Import

val build_o_files :
     sctx:Super_context.t
  -> foreign_sources:Foreign.Sources.t
  -> dir:Path.Build.t
  -> expander:Expander.t
  -> requires:Lib.L.t Resolve.t
  -> dir_contents:Dir_contents.t
  -> Path.t Foreign.Source.for_mode list Memo.Build.t
