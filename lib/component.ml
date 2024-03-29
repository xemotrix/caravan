type t = ..

module ID = (val ID.make ())

module type T = sig
  type data

  val id : ID.t
  val of_component : t -> data
  val to_component : data -> t
end

module type COMPONENT_BASE = sig
  type data

  val of_component : t -> data
  val to_component : data -> t
end

module Make (Base : COMPONENT_BASE) : T with type data = Base.data = struct
  include Base

  let id = ID.next ()
end
