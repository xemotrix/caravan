module T = struct
  type t = int [@@deriving compare, sexp]

  let entity_id = Atomic.make 0
  let next () = Atomic.fetch_and_add entity_id 1
  let hash t : int = t
end

include T
