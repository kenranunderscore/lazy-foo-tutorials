open Tsdl
open Rresult

let screen_width = 640
let screen_height = 480

let cleanup format window =
  let _ = Sdl.free_format format in
  let _ = Sdl.destroy_window window in
  Sdl.quit ()

let () =
  let sdl_result = Sdl.init Sdl.Init.video >>= fun _ ->
  Sdl.create_window ~w:screen_width ~h:screen_height "SDL Tutorial" Sdl.Window.shown >>= fun window ->
  Sdl.get_window_surface window >>= fun surface ->
  surface |> Sdl.get_surface_format_enum |> Sdl.alloc_format >>= fun f ->
  Sdl.fill_rect surface None (Sdl.map_rgb f 0 30 0) >>= fun _ ->
  Sdl.update_window_surface window >>= fun _ ->
  let _ = Sdl.delay 2000l in
  Ok (f, window)
  in
  let _ = match sdl_result with
    | Ok (f, window) ->
      cleanup f window;
      print_endline "Success!"
    | Error (`Msg e) ->
      Sdl.log "Something happened: %s" e
  in
  Sdl.quit ()
