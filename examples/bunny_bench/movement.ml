open Core
open Caravan

module T = System.Make (struct
    let main_component = Position.id
    let must_have = [ Velocity.id ]
    let pre w = w
    let post w = w

    let update_entity (w : World.t) (e : Entity.t) (c : Component.t) =
      let pos = Position.of_component c in
      let vel = World.query_single_component w e (module Velocity) in
      match vel with
      | None -> ()
      | Some vel ->
        let open Raylib in
        let module V = Raylib.Vector2 in
        let x = V.x pos in
        let y = V.y pos in
        if Float.(x < 0. || x > float_of_int @@ get_screen_width ())
        then V.set_x vel (V.x vel *. -1.);
        if Float.(y < 0. || y > float_of_int @@ get_screen_height ())
        then V.set_y vel (V.y vel *. -1.);
        V.set_x pos (V.x pos +. V.x vel);
        V.set_y pos (V.y pos +. V.y vel)
    ;;
  end)

include T
