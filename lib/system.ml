module type T = sig
  val update : World.t -> World.t
end

module type SYSTEM_BASE = sig
  val main_component : Component.ID.t
  val must_have : Component.ID.t list
  val pre : World.t -> World.t
  val post : World.t -> World.t
  val update_entity : World.t -> Entity.t -> Component.t -> unit
end

module Make (Base : SYSTEM_BASE) : T = struct
  let update (w : World.t) : World.t =
    w
    |> Base.pre
    |> World.get_store ~comp_id:Base.main_component
    |> Store.iteri ~f:(fun ~key ~data -> Base.update_entity w key data);
    Base.post w
  ;;
end
