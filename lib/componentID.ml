type t = int [@@deriving compare, sexp, eq]

let id = Atomic.make 0
let next () = Atomic.fetch_and_add id 1
let hash t : int = t
