type t = ..

module type T = sig
  type data

  val id : ComponentID.t
  val of_component : t -> data
  val to_component : data -> t
end

module type COMPONENT_BASE = sig
  type data

  val of_component : t -> data
  val to_component : data -> t
end

(** A functor that creates a component from a module that satisfies [COMPONENT_BASE].
    Example:

    {[
      module Color = Make (struct
          type data = Raylib.Color.t
          type t += Color of data

          let of_component = function
            | Color t -> t
            | _ -> failwith "bad value"
          ;;

          let to_component t = Color t
        end)
    ]} *)
module Make : functor (Base : COMPONENT_BASE) -> T with type data = Base.data
