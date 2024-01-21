open Caravan
open Core

module T = System.Make (struct
    let main_component = Color.id
    let must_have = [ Position.id; Texture.id ]

    let pre (w : World.t) : World.t =
      let open Raylib in
      begin_drawing ();
      clear_background Color.black;
      w
    ;;

    let post (w : World.t) : World.t =
      let open Raylib in
      draw_rectangle 0 0 100 50 Color.white;
      draw_rectangle 1 1 98 48 Color.black;
      draw_fps 10 10;
      end_drawing ();
      w
    ;;

    let update_entity (w : World.t) (e : Entity.t) (col_c : Component.t) =
      let pos = World.query_single_component w e (module Position) in
      let tex = World.query_single_component w e (module Texture) in
      match Option.both pos tex with
      | None -> ()
      | Some (pos, tex) -> Raylib.draw_texture_v tex pos (Color.of_component col_c)
    ;;
  end)

include T
