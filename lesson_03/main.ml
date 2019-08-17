open Rresult
open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let event_loop window screen_surface bitmap_surface () =
  let e = Sdl.Event.create () in
  let rec loop () =
    match Sdl.wait_event (Some e) with
    | Error (`Msg error) ->
      Sdl.log "Could not wait for event: %s" error;
      ()
    | Ok () ->
      match Sdl.Event.(enum (get e typ)) with
      | `Quit ->
        print_endline "Received SDL_QUIT"
      | _ ->
        match
          Sdl.blit_surface ~src:bitmap_surface None ~dst:screen_surface None >>= fun _ ->
          Sdl.update_window_surface window
        with
        | Error (`Msg error) ->
          Sdl.log "Something went wrong: %s" error
        | Ok _ ->
          loop ()
  in
  Sdl.start_text_input ();
  loop ()

let _ =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun window ->
  Utils.with_window_surface window @@ fun screen_surface ->
  Utils.with_bitmap "x.bmp" @@ fun bitmap_surface ->
  event_loop window screen_surface bitmap_surface ();
  Ok ()
