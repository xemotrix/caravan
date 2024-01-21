open Core
open Caravan

let add_bot (w : World.t) tex =
  let bot = Entity.next () in
  let pos =
    Position.to_component
      Raylib.(Vector2.create (200. +. Random.float 200.) (200. +. Random.float 500.))
  in
  let vel =
    Velocity.to_component
      Raylib.(Vector2.create (Random.float 6. -. 3.) (Random.float 6. -. 3.))
  in
  let col =
    Color.to_component
      Raylib.(Color.create (Random.int 255) (Random.int 255) (Random.int 255) 255)
  in
  let tex = Texture.to_component tex in
  World.add
    w
    bot
    [ (module Position), pos
    ; (module Velocity), vel
    ; (module Color), col
    ; (module Texture), tex
    ]
;;

let rec fill_world (w : World.t) ~(n : int) ~tex =
  match n with
  | 0 -> w
  | _ -> fill_world (add_bot w tex) ~n:(n - 1) ~tex
;;

let setup =
  Raylib.set_config_flags [ Window_resizable ];
  Raylib.init_window 1000 500 "raylib test";
  Raylib.set_target_fps 60;
  let tex = Raylib.load_texture "examples/bunny_bench/assets/wabbit_alpha.png" in
  let components : (module Component.T) list =
    [ (module Position); (module Velocity); (module Color); (module Texture) ]
  in
  World.empty () |> World.add_component_types ~components |> fill_world ~n:50000 ~tex
;;

let update w = w |> Movement.update
let draw w = w |> Render.update

let rec loop (w : World.t) =
  let open Raylib in
  match window_should_close () with
  | true -> close_window ()
  | false -> w |> update |> draw |> loop
;;

let () = setup |> loop
