open Caravan.Component

module T = Make (struct
    type data = Raylib.Texture2D.t
    type t += Texture of data

    let of_component = function
      | Texture p -> p
      | _ -> failwith "bad value"
    ;;

    let to_component p = Texture p
  end)

include T
