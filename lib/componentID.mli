type t [@@deriving compare, sexp, eq]

val next : unit -> t
val hash : t -> int
