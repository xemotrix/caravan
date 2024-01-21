type t = (Entity.t, Component.t) Hashtbl.t

let empty () : t = Hashtbl.create (module Entity)

let set t key data : t =
  Hashtbl.set t ~key ~data;
  t
;;

let find (m : t) ~entity:k = Hashtbl.find m k
let find_exn (m : t) ~entity:k = Hashtbl.find_exn m k
let iteri = Hashtbl.iteri
