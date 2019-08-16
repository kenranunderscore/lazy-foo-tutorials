open Tsdl

module Utils = struct

  exception Sdl_error of string

  let with_msg msg (action: unit -> 'a) =
    print_endline msg;
    action ()

  let bracket acquire release body =
    match acquire () with
    | Error (`Msg e) as error -> Sdl.log "An error occurred: %s" e; error
    | Ok resource ->
      let res = body resource in
      release resource;
      res

  let init_sdl_video () =
    (fun _ -> Sdl.init Sdl.Init.video)
    |> with_msg "Initializing SDL"

  let with_sdl body =
    bracket
      init_sdl_video
      (fun _ ->
         Sdl.quit
         |> with_msg "Quitting SDL")
      body

  let create_window width height title =
    (fun _ -> Sdl.create_window ~w:width ~h:height title Sdl.Window.shown)
    |> with_msg @@ "Creating window '" ^ title ^ "'"

  let with_window width height title =
    bracket
      (fun _ -> create_window width height title)
      (fun window ->
         (fun _ -> Sdl.destroy_window window)
         |> with_msg "Destroying window")

end
