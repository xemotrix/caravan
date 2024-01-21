type t [@@deriving compare, sexp]

val next : unit -> t
val hash : t -> int
