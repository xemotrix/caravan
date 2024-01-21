module type T = sig
  type t [@@deriving compare, sexp, eq]

  val next : unit -> t
  val hash : t -> int
end

let make () : (module T) =
  let module M : T = struct
    type t = int [@@deriving compare, sexp, eq]

    let id = Atomic.make 0
    let next () = Atomic.fetch_and_add id 1
    let hash t : int = t
  end
  in
  (module M)
;;
