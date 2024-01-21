type t

(** [empty ()] returns an empty world *)
val empty : unit -> t

(** [add_component_type t comp_id] adds a component type to the world *)
val add_component_type : t -> (module Component.T) -> t

(** [add_component_types t comp_ids] adds a list of component types to the world *)
val add_component_types : t -> components:(module Component.T) list -> t

(** [find_exn t comp_id] returns the store for the component type [comp_id] *)
val find_exn : t -> comp_id:ComponentID.t -> Store.t

(** [add t entity comps] adds an entity [entity] with its components [comps] to the world *)
val add : t -> Entity.t -> ((module Component.T) * Component.t) list -> t

(** [query_entities t comp_ids] returns the entities that have all the components in [comp_ids] *)
val query_entities : t -> (module Component.T) list -> Entity.t array

(** [query_single_component t entity comp] returns the component of type [comp] for the entity [entity] *)
val query_single_component
  :  t
  -> Entity.t
  -> (module Component.T with type data = 'a)
  -> 'a option

(** [set_component t entity comp_mod comp] sets the component of type [comp_mod] of [entity] to [comp] *)
val set_component : t -> Entity.t -> (module Component.T with type data = 'a) -> 'a -> t

(** [get_store t comp_id] returns the store for the component type [comp_id] *)
val get_store : t -> comp_id:ComponentID.t -> Store.t

(** [entity_has_components t entity comp_ids] returns true if the entity [entity] has all the components in [comp_ids] *)
val entity_has_components : t -> Entity.t -> ComponentID.t list -> bool
