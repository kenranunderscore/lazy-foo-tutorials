open Tsdl

let screen_width = 640
let screen_height = 480

exception SdlException of string

let unwrap res =
  match res with
  | Ok x -> x
  | Error (`Msg e) -> raise (SdlException e)

let () =
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) ->
    Sdl.log "SDL could not initialize! SDL_Error: %s" e;
    exit 1
  | Ok () ->
    match Sdl.create_window ~w:screen_width ~h:screen_height "SDL Tutorial" Sdl.Window.shown with
    | Error (`Msg e) ->
      Sdl.log "Window could not be created! SDL_Error: %s" e;
      exit 1
    | Ok window ->
      let screen_surface = Sdl.get_window_surface window |> unwrap in
      print_endline "here";
      let f = screen_surface
              |> Sdl.get_surface_format_enum
              |> Sdl.alloc_format
              |> unwrap
      in
      let _ = Sdl.fill_rect screen_surface None (Sdl.map_rgb f 0 30 0) |> unwrap in
      Sdl.update_window_surface window |> unwrap |> ignore;
      Sdl.delay 2000l;
      Sdl.free_format f;
      Sdl.destroy_window window;
      Sdl.quit ()
