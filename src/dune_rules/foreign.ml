open! Dune_engine
open Stdune

let encode_lang = function
  | Foreign_language.C -> "c"
  | Cxx -> "cxx"

let decode_lang =
  let open Foreign_language in
  Dune_lang.Decoder.enum [ (encode_lang C, C); (encode_lang Cxx, Cxx) ]

let drop_source_extension fn ~dune_version =
  let open Option.O in
  let* obj, ext = String.rsplit2 fn ~on:'.' in
  let* language, version =
    String.Map.find Foreign_language.source_extensions ext
  in
  Option.some_if (dune_version >= version) (obj, language)

let possible_sources ~language obj ~dune_version =
  List.filter_map (String.Map.to_list Foreign_language.source_extensions)
    ~f:(fun (ext, (lang, version)) ->
      Option.some_if
        (Foreign_language.equal lang language && dune_version >= version)
        (obj ^ "." ^ ext))

module Archive = struct
  module Name = struct
    include String

    let to_string t = t

    let path ~dir t = Path.Build.relative dir t

    let decode =
      Dune_lang.Decoder.plain_string (fun ~loc s ->
          match s with
          | "."
          | ".." ->
            User_error.raise ~loc
              [ Pp.textf "%S is not a valid archive name." s ]
          | fn when String.exists fn ~f:Path.is_dir_sep ->
            User_error.raise ~loc
              [ Pp.textf "Path separators are not allowed in archive names." ]
          | fn -> fn)

    let stubs archive_name = archive_name ^ "_stubs"

    let lib_file_prefix = "lib"

    let lib_file archive_name ~dir ~ext_lib =
      Path.Build.relative dir
        (sprintf "%s%s%s" lib_file_prefix archive_name ext_lib)

    let dll_file archive_name ~dir ~ext_dll =
      Path.Build.relative dir (sprintf "dll%s%s" archive_name ext_dll)

    let add_mode_suffix t (mode : Mode.t) =
      match mode with
      | Byte -> t ^ "_byte"
      | Native -> t ^ "_native"
  end

  (** Archive directories can appear as part of the [(foreign_archives ...)]
      fields. For example, in [(foreign_archives some/dir/lib1 lib2)], the
      archive [some/dir/lib1] has the directory [some/dir], whereas the archive
      [lib2] does not specify the directory and is assumed to be located in [.]. *)
  module Dir = struct
    type t = string
  end

  type t =
    { dir : Dir.t
    ; name : Name.t
    }

  let dir_path ~dir t = Path.Build.relative dir t.dir

  let name t mode = Name.add_mode_suffix t.name mode

  let stubs archive_name = { dir = "."; name = Name.stubs archive_name }

  let decode =
    let open Dune_lang.Decoder in
    let+ s = string in
    { dir = Filename.dirname s; name = Filename.basename s }

  let lib_file ~archive mode ~dir ~ext_lib =
    let dir = dir_path ~dir archive in
    Name.lib_file (name archive mode) ~dir ~ext_lib

  let dll_file ~archive ~dir ~ext_dll =
    let dir = dir_path ~dir archive in
    Name.dll_file (name archive Byte) ~dir ~ext_dll
end

module Compilation_mode = struct
  type t =
  | All | Only of Mode.t

  let decode =
    let open Dune_lang.Decoder in
    let+ mode = field_o "mode" Mode.decode in
    match mode with
    | None -> All
    | Some m -> Only m
  let equal = ( = )
end

module Stubs = struct
  module Include_dir = struct
    type t =
      | Dir of String_with_vars.t
      | Lib of Loc.t * Lib_name.t

    let decode : t Dune_lang.Decoder.t =
      let open Dune_lang.Decoder in
      let parse_dir =
        let+ s = String_with_vars.decode in
        Dir s
      in
      let parse_lib =
        let+ loc, lib_name = sum [ ("lib", located Lib_name.decode) ] in
        Lib (loc, lib_name)
      in
      parse_lib <|> parse_dir
  end

  type t =
    { loc : Loc.t
    ; language : Foreign_language.t
    ; mode : Compilation_mode.t
    ; names : Ordered_set_lang.t
    ; flags : Ordered_set_lang.Unexpanded.t
    ; include_dirs : Include_dir.t list
    ; extra_deps : Dep_conf.t list
    }

  let make ~loc ~language ~names ~flags =
    let mode = Compilation_mode.All in
    { loc; language; mode; names; flags; include_dirs = []; extra_deps = [] }

  let decode_stubs =
    let open Dune_lang.Decoder in
    let+ loc = loc
    and+ loc_archive_name, archive_name =
      located (field_o "archive_name" string)
    and+ language = field "language" decode_lang
    and+ mode = Compilation_mode.decode
    and+ names = Ordered_set_lang.field "names"
    and+ flags = Ordered_set_lang.Unexpanded.field "flags"
    and+ include_dirs =
      field ~default:[] "include_dirs" (repeat Include_dir.decode)
    and+ extra_deps = field_o "extra_deps" (repeat Dep_conf.decode) in
    let extra_deps = Option.value ~default:[] extra_deps in
    let () =
      match archive_name with
      | None -> ()
      | Some _ ->
        User_error.raise ~loc:loc_archive_name
          [ Pp.textf
              "The field \"archive_name\" is not allowed in the (foreign_stubs \
               ...) stanza. For named foreign archives use the \
               (foreign_library ...) stanza."
          ]
    in
    { loc; language; mode; names; flags; include_dirs; extra_deps }

  let decode = Dune_lang.Decoder.fields decode_stubs
end

module Library = struct
  type t =
    { archive_name : Archive.Name.t
    ; archive_name_loc : Loc.t
    ; stubs : Stubs.t
    }

  let decode =
    let open Dune_lang.Decoder in
    fields
      (let+ archive_name_loc, archive_name =
         located (field "archive_name" Archive.Name.decode)
       and+ stubs = Stubs.decode_stubs in
       { archive_name; archive_name_loc; stubs })
end

module Source = struct
  (* we store the entire [stubs] record even though [t] only describes an
     individual source file *)
  type t =
    { stubs : Stubs.t
    ; path : Path.Build.t
    }

  type with_loc = Loc.t * t

  let language t = t.stubs.language

  let mode t = t.stubs.mode

  let flags t = t.stubs.flags

  let path t = t.path

  let object_name t =
    t.path |> Path.Build.split_extension |> fst |> Path.Build.basename

  let make ~stubs ~path = { stubs; path }

  module For_mode = struct
    type 'a t =
      { byte : 'a option
      ; native : 'a option
      }

    let empty = { byte = None; native = None }

    let map ~f { byte; native } =
      { byte = Option.map ~f byte; native = Option.map ~f native }

    let to_list_map ~f { byte; native } =
      match (byte, native) with
      | Some byte, Some _
        when mode (snd byte) = Compilation_mode.All ->
        [ f Compilation_mode.All byte ]
      | Some byte, Some native ->
        [ f (Compilation_mode.Only Byte) byte
        ; f (Compilation_mode.Only Native) native
        ]
      | Some s, None
      | None, Some s ->
        [ f (mode (snd s)) s ]
      | None, None -> []

    let from_source source =
      let open Compilation_mode in
      match mode (snd source) with
      | Only Byte -> { empty with byte = Some source }
      | Only Native -> { empty with native = Some source }
      | All -> { byte = Some source; native = Some source }

    let add_source t source_with_loc =
      let open Compilation_mode in
      let source = snd source_with_loc in
      match (mode (snd source_with_loc), t) with
      | Only Byte, { byte = None; native } ->
        Ok { byte = Some source_with_loc; native }
      | Only Native, { byte; native = None } ->
        Ok { byte; native = Some source_with_loc }
      | All, { byte = None; native = None } ->
        Ok { byte = Some source_with_loc; native = Some source_with_loc }
      | _, { byte = Some (loc, src2); _ }
      | _, { native = Some (loc, src2); _ } ->
        Error (loc, [ source.path; src2.path ])

    let union { byte; native } t2 =
      let open Result.O in
      let* t =
        Option.map byte ~f:(add_source t2) |> Option.value ~default:(Ok t2)
      in
      Option.map native ~f:(add_source t2) |> Option.value ~default:(Ok t)
  end
end

module Sources = struct
  type t = Source.with_loc Source.For_mode.t String.Map.t

  let object_files t ~dir ~ext_obj =
    String.Map.keys t
    |> List.map ~f:(fun c -> Path.Build.relative dir (c ^ ext_obj))

  module Unresolved = struct
    type t = (Foreign_language.t * Path.Build.t) String.Map.Multi.t

    let to_dyn t =
      String.Map.to_dyn
        (fun xs ->
          Dyn.List
            (List.map xs ~f:(fun (language, path) ->
                 Dyn.Tuple
                   [ Foreign_language.to_dyn language; Path.Build.to_dyn path ])))
        t

    let load ~dune_version ~dir ~files =
      let init = String.Map.empty in
      String.Set.fold files ~init ~f:(fun fn acc ->
          match drop_source_extension fn ~dune_version with
          | None -> acc
          | Some (obj, language) ->
            let path = Path.Build.relative dir fn in
            String.Map.add_multi acc obj (language, path))
  end
end
