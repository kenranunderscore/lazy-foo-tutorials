open Tsdl

module Utils : sig

  exception Sdl_error of string

  val bracket: (unit -> 'a Sdl.result) -> ('a -> unit) -> ('a -> 'b) -> 'b
  val with_sdl: (unit -> 'a) -> 'a
  val with_window: int -> int -> string -> (Sdl.window -> 'b) -> 'b

end
