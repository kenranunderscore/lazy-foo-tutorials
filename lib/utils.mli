open Tsdl

module Utils : sig

  exception Sdl_error of string

  val const: 'a -> ('b -> 'a)
  val bracket: (unit -> 'a Sdl.result) -> ('a -> unit) -> ('a -> 'b Sdl.result) -> 'b Sdl.result
  val with_sdl: (unit -> 'a Sdl.result) -> 'a Sdl.result
  val with_window: int -> int -> string -> (Sdl.window -> 'a Sdl.result) -> 'a Sdl.result
  val with_window_surface: Sdl.window -> (Sdl.surface -> 'a Sdl.result) -> 'a Sdl.result

end
