open Rresult
open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let _ =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun window ->
  Utils.with_window_surface window @@ fun surface ->
  surface
  |> Sdl.get_surface_format_enum
  |> Sdl.alloc_format >>= fun format ->
  Sdl.fill_rect surface None (Sdl.map_rgb format 50 0 50) >>= fun _ ->
  Sdl.update_window_surface window >>= fun _ ->
  let _ = Sdl.delay 2000l in
  Sdl.free_format format;
  print_endline "done!";
  Ok ()
