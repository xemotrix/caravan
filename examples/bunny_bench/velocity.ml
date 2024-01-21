open Caravan.Component

module T = Make (struct
    type data = Raylib.Vector2.t
    type t += Velocity of data

    let of_component = function
      | Velocity x -> x
      | _ -> failwith "bad value"
    ;;

    let to_component x = Velocity x
  end)

include T
