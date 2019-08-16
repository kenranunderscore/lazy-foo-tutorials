open Rresult
open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let _ =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun window ->
  Utils.with_window_surface window @@ fun surface ->
  Utils.with_bitmap "hello_world.bmp" @@ fun bitmap_surface ->
  Sdl.blit_surface ~src:bitmap_surface None ~dst:surface None >>= fun _ ->
  Sdl.update_window_surface window >>= fun _ ->
  Sdl.delay 2000l;
  print_endline "done!";
  Ok ()
