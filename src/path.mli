open Import

(** In the current workspace (anything under the current project root) *)
module Local : sig
  type t

  val compare : t -> t -> int

  module Set : Set.S with type elt = t

  val root : t
  val is_root : t -> bool
  val to_string : t -> string
  val mkdir_p : t -> unit
  val ensure_parent_directory_exists : t -> unit
  val append : t -> t -> t
  val descendant : t -> of_:t -> t option
  val parent : t -> t
end

(** In the outside world *)
module External : sig
  type t

  val to_string : t -> string
end

module Kind : sig
  type t =
    | External of External.t
    | Local    of Local.t
end

type t

val t : t Sexp.Of_sexp.t
val sexp_of_t : t Sexp.To_sexp.t

val compare : t -> t -> int

module Set : Set.S with type elt = t
module Map : Map.S with type key = t

val kind : t -> Kind.t

val of_string : string -> t
val to_string : t -> string

val root : t
val is_root : t -> bool

val is_local : t -> bool

val relative : t -> string -> t

val absolute : string -> t

val reach : t -> from:t -> string
val reach_for_running : t -> from:t -> string

val descendant : t -> of_:t -> t option
val is_descendant : t -> of_:t -> bool

val append : t -> t -> t

val basename : t -> string
val parent : t -> t

val extend_basename : t -> suffix:string -> t

(** Extract the build context from a path. For instance, representing paths as strings:

    {[
      extract_build_context "_build/blah/foo/bar" = Some ("blah", "foo/bar")
    ]}
*)
val extract_build_context : t -> (string * t) option

(** Same as [extract_build_context] but return the build context as a path:

    {[
      extract_build_context "_build/blah/foo/bar" = Some ("_build/blah", "foo/bar")
    ]}
*)
val extract_build_context_dir : t -> (t * t) option

(** Drop the "_build/blah" prefix *)
val drop_build_context : t -> t

val is_in_build_dir : t -> bool

val insert_after_build_dir_exn : t -> t -> t

val exists : t -> bool
val readdir : t -> string list
val is_directory : t -> bool
val rmdir : t -> unit
val unlink : t -> unit
val unlink_no_err : t -> unit
val rm_rf : t -> unit
