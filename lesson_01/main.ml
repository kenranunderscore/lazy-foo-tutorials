open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let _ =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun _ ->
  let _ = Sdl.delay 2000l in
  print_endline "done!";
  Ok ()
