open Caravan.Component

module T = Make (struct
    type data = Raylib.Vector2.t
    type t += Position of data

    let of_component = function
      | Position p -> p
      | _ -> failwith "bad value"
    ;;

    let to_component p = Position p
  end)

include T
