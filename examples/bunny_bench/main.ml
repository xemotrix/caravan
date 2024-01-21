open Core
open Caravan

let random_vector min max : Raylib.Vector2.t =
  let mag = max -. min in
  Raylib.Vector2.create (Random.float mag +. min) (Random.float mag +. min)
;;

let random_color () : Raylib.Color.t =
  let open Random in
  Raylib.Color.create (int 255) (int 255) (int 255) 255
;;

let add_bot world ~tex : World.t =
  let open World in
  let open Result in
  world
  |> init_entity ~entity:(Entity.next ())
  >>= with_component ~kind:(module Position) ~data:(random_vector 200. 400.)
  >>= with_component ~kind:(module Velocity) ~data:(random_vector (-5.) 5.)
  >>= with_component ~kind:(module Color) ~data:(random_color ())
  >>= with_component ~kind:(module Texture) ~data:tex
  >>= add
  |> ok_or_failwith
;;

let fill_world world : World.t =
  let tex = Raylib.load_texture "examples/bunny_bench/assets/wabbit_alpha.png" in
  Fn.apply_n_times ~n:50000 (add_bot ~tex) world
;;

let setup_raylib () : unit =
  let open Raylib in
  set_config_flags [ Window_resizable ];
  init_window 1000 500 "raylib test";
  set_target_fps 60
;;

let setup : World.t =
  setup_raylib ();
  World.(
    empty ()
    |> init_component (module Position)
    |> init_component (module Velocity)
    |> init_component (module Color)
    |> init_component (module Texture))
  |> fill_world
;;

let rec loop (w : World.t) : unit =
  let open Raylib in
  match window_should_close () with
  | true -> close_window ()
  | false -> w |> Movement.update |> Render.update |> loop
;;

let () = setup |> loop
