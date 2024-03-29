open Tsdl
open Rresult

module Utils = struct

  exception Sdl_error of string

  let const a _ =
    a

  let with_msg msg (action: unit -> 'a) =
    print_endline msg;
    action ()

  let bracket acquire release body =
    match acquire () with
    | Error (`Msg e) as error ->
      Sdl.log "An error occurred: %s" e;
      error
    | Ok resource ->
      let res = body resource in
      release resource;
      res

  let init_sdl_video () =
    const (Sdl.init Sdl.Init.video)
    |> with_msg "Initializing SDL"

  let with_sdl body =
    bracket
      init_sdl_video
      (fun _ ->
         Sdl.quit
         |> with_msg "Quitting SDL")
      body

  let create_window width height title =
    const (Sdl.create_window ~w:width ~h:height title Sdl.Window.shown)
    |> with_msg @@ "Creating window '" ^ title ^ "'"

  let with_window width height title =
    bracket
      (fun _ -> create_window width height title)
      (fun window ->
         const (Sdl.destroy_window window)
         |> with_msg "Destroying window")

  let with_window_surface window =
    bracket
      (fun _ ->
         print_endline "Getting window surface";
         Sdl.get_window_surface window)
      (fun surface ->
         const (Sdl.free_surface surface)
         |> with_msg "Freeing window surface")

  let with_bitmap path =
    bracket
      (fun _ ->
         print_endline ("Loading bitmap '" ^ path ^ "'");
         Sdl.load_bmp path)
      (fun surface ->
         const (Sdl.free_surface surface)
         |> with_msg ("Freeing bitmap surface '" ^ path ^ "'"))

  let with_bitmap_optimized path screen_surface =
    bracket
      (fun _ ->
         print_endline ("Loading bitmap '" ^ path ^ "' with optimization");
         let target_format = Sdl.get_surface_format_enum screen_surface in
         with_bitmap path @@ fun surface ->
         Sdl.convert_surface_format surface target_format)
      (fun surface ->
         const (Sdl.free_surface surface)
         |> with_msg ("Freeing optimized surface '" ^ path ^ "'"))

end
