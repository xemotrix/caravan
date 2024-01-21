type t

(** [empty ()] is an empty component map. *)
val empty : unit -> t

(** [set t entity component] returns [t] with a [component] associated to [entity] *)
val set : t -> Entity.t -> Component.t -> t

(** [find t entity] returns the component associated to [entity] in [t] *)
val find : t -> entity:Entity.t -> Component.t option

(** [find_exn t entity] returns the component associated to [entity] in [t]
    @raise exception if no component is associated to [entity] *)
val find_exn : t -> entity:Entity.t -> Component.t

(** [iteri t ~f] applies [f] to all the components of [t] *)
val iteri : t -> f:(key:Entity.t -> data:Component.t -> unit) -> unit
