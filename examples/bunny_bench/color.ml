open Caravan.Component

module T = Make (struct
    type data = Raylib.Color.t
    type t += Color of data

    let of_component = function
      | Color t -> t
      | _ -> failwith "bad value"
    ;;

    let to_component t = Color t
  end)

include T
