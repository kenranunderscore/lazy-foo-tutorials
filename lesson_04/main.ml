open Rresult
open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let choose_surface event event_type current up down left right =
  match event_type with
  | `Key_down ->
    let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
    if keycode == Sdl.K.up then up
    else if keycode == Sdl.K.down then down
    else if keycode == Sdl.K.left then left
    else if keycode == Sdl.K.right then right
    else current
  | _ ->
    current

let event_loop window screen default up down left right () =
  let e = Sdl.Event.create () in
  let rec loop current_surface () =
    match Sdl.poll_event (Some e) with
    | false -> loop current_surface ()
    | true ->
      let event_type = Sdl.Event.(enum (get e typ)) in
      let quit_received = event_type == `Quit in
      let next_surface = choose_surface e event_type current_surface up down left right in
      match
        Sdl.blit_surface ~src:next_surface None ~dst:screen None >>= fun _ ->
        Sdl.update_window_surface window
      with
      | Error (`Msg error) ->
        Sdl.log "Something went wrong: %s" error
      | Ok _ ->
        if quit_received then () else loop next_surface ()
  in
  loop default ()

let _ =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun window ->
  Utils.with_window_surface window @@ fun screen_surface ->
  Utils.with_bitmap "resources/press.bmp" @@ fun default_surface ->
  Utils.with_bitmap "resources/up.bmp" @@ fun up_surface ->
  Utils.with_bitmap "resources/down.bmp" @@ fun down_surface ->
  Utils.with_bitmap "resources/left.bmp" @@ fun left_surface ->
  Utils.with_bitmap "resources/right.bmp" @@ fun right_surface ->
  event_loop window screen_surface default_surface up_surface down_surface left_surface right_surface ();
  Ok ()
