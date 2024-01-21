type t = (Entity.t, Component.t) Hashtbl.t

let empty () : t = Hashtbl.create (module Entity)

let set t key data : t =
  Hashtbl.set t ~key ~data;
  t
;;

let find t ~entity:k = Hashtbl.find t k
let iteri = Hashtbl.iteri
