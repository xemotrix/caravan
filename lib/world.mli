type t

(** [empty ()] returns an empty world *)
val empty : unit -> t

(** [init_component t comp_id] adds a component type to the world *)
val init_component : (module Component.T) -> t -> t

(** [query_single_component t entity comp] returns the component of type [comp] for the entity [entity] *)
val query_single_component
  :  t
  -> Entity.t
  -> (module Component.T with type data = 'a)
  -> 'a option

(** [get_store t comp_id] returns the store for the component type [comp_id] *)
val get_store : t -> comp_id:Component.ID.t -> Store.t

(** [init_entity t entity] initializes the entity [entity] in the world [t].
    After initialization, you can use the [with_component] function to add
    components associated with the entity and finally use [add] to add the
    entity to the world. Example:
    {[
      let open World in
      let open Result in
      world
      |> init_entity ~entity:(Entity.next ())
      >>= with_component ~kind:(module Position) ~data:some_position
      >>= with_component ~kind:(module Velocity) ~data:some_velocity
      >>= with_component ~kind:(module Color) ~data:some_color
      >>= with_component ~kind:(module Texture) ~data:some_texture
      >>= add
      |> ok_or_failwith
    ]} *)
val init_entity : t -> entity:Entity.t -> (t, string) Result.t

(** [with_component t comp_id data] adds the component [data] of type [comp_id] to the entity
    associated with the world [t]. *)
val with_component
  :  t
  -> kind:(module Component.T with type data = 'a)
  -> data:'a
  -> (t, string) Result.t

val add : t -> (t, string) Result.t
