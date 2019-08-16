open Tsdl
open Utils

let screen_width = 640
let screen_height = 480

let cleanup format window =
  let _ = Sdl.free_format format in
  let _ = Sdl.destroy_window window in
  Sdl.quit ()

let () =
  Utils.with_sdl @@ fun _ ->
  Utils.with_window screen_width screen_height "SDL Tutorial" @@ fun _ ->
  let _ = Sdl.delay 2000l in
  print_endline "done!"
