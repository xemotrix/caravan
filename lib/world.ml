type t =
  { cmap : (Component.ID.t, Store.t) Hashtbl.t
  ; emap : (Entity.t, Component.ID.t list) Hashtbl.t
  ; last_entity : Entity.t option
  }

let empty () : t =
  { cmap = Hashtbl.create (module Component.ID)
  ; emap = Hashtbl.create (module Entity)
  ; last_entity = None
  }
;;

let init_component (module M : Component.T) (t : t) : t =
  Hashtbl.set t.cmap ~key:M.id ~data:(Store.empty ());
  t
;;

let query_single_component
  (type a)
  (t : t)
  (entity : Entity.t)
  (comp_mod : (module Component.T with type data = a))
  : a option
  =
  let module C = (val comp_mod) in
  let open Option.Monad_infix in
  Hashtbl.find t.cmap C.id >>= Store.find ~entity >>| C.of_component
;;

let get_store (t : t) ~(comp_id : Component.ID.t) : Store.t =
  Hashtbl.find_exn t.cmap comp_id
;;

let init_entity (t : t) ~entity:(key : Entity.t) : (t, string) Result.t =
  match t.last_entity with
  | None ->
    Hashtbl.set t.emap ~key ~data:[];
    Ok { t with last_entity = Some key }
  | Some _ -> Error "cannot init_entity twice without calling add"
;;

let with_component
  (type a)
  (t : t)
  ~(kind : (module Component.T with type data = a))
  ~(data : a)
  =
  match t.last_entity with
  | None -> Error "init_entity not called"
  | Some entity ->
    let module C = (val kind) in
    Hashtbl.update t.cmap C.id ~f:(function
      | None -> failwith "component not found"
      | Some store -> Store.set store entity (C.to_component data));
    Hashtbl.update t.emap entity ~f:(function
      | None -> failwith "entity not found"
      | Some ids -> C.id :: ids);
    Ok t
;;

let add (t : t) : (t, string) Result.t =
  match t.last_entity with
  | None -> Error "init_entity not called"
  | Some _ -> Ok { t with last_entity = None }
;;
