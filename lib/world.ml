type t =
  { cmap : (ComponentID.t, Store.t) Hashtbl.t
  ; emap : (Entity.t, ComponentID.t list) Hashtbl.t
  }

let empty () : t =
  { cmap = Hashtbl.create (module ComponentID); emap = Hashtbl.create (module Entity) }
;;

let add_component_type (t : t) (module M : Component.T) : t =
  Hashtbl.set t.cmap ~key:M.id ~data:(Store.empty ());
  t
;;

let rec add_component_types (t : t) ~(components : (module Component.T) list) : t =
  match components with
  | [] -> t
  | m :: rest -> add_component_type t m |> add_component_types ~components:rest
;;

let find_exn (m : t) ~comp_id = Hashtbl.find_exn m.cmap comp_id

let add
  (t : t)
  (entity : Entity.t)
  (components : ((module Component.T) * Component.t) list)
  =
  let ids =
    List.map components ~f:(fun (m, _) ->
      let module C = (val m) in
      C.id)
  in
  Hashtbl.set t.emap ~key:entity ~data:ids;
  let rec add' t entity (components : ((module Component.T) * Component.t) list) =
    match components with
    | [] -> t
    | (comp_mod, comp_val) :: rest ->
      let module C = (val comp_mod) in
      Hashtbl.update t.cmap C.id ~f:(function
        | None -> failwith "component not found"
        | Some store -> Store.set store entity comp_val);
      add' t entity rest
  in
  add' t entity components
;;

let query_entities (t : t) (comp_mods : (module Component.T) list) : Entity.t array =
  Hashtbl.filter t.emap ~f:(fun comp_ids ->
    List.for_all comp_mods ~f:(fun comp_mod ->
      let module C = (val comp_mod) in
      List.mem comp_ids C.id ~equal:ComponentID.equal))
  |> Hashtbl.keys
  |> Array.of_list
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

let set_component
  (type a)
  (t : t)
  (entity : Entity.t)
  (comp_mod : (module Component.T with type data = a))
  (comp : a)
  : t
  =
  let module C = (val comp_mod) in
  Hashtbl.update t.cmap C.id ~f:(function
    | None -> failwith "whaat"
    | Some store -> Store.set store entity (C.to_component comp));
  t
;;

let get_store (t : t) ~(comp_id : ComponentID.t) : Store.t =
  Hashtbl.find_exn t.cmap comp_id
;;

let entity_has_components (t : t) (entity : Entity.t) (comp_ids : ComponentID.t list)
  : bool
  =
  let comps = Hashtbl.find_exn t.emap entity in
  List.for_all comp_ids ~f:(fun comp_id ->
    List.mem comps comp_id ~equal:ComponentID.equal)
;;
