module Lesson01 where

import           Relude

import qualified SDL
import qualified Utils

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 01" SDL.defaultWindow $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface -> do
    let white = SDL.V4 maxBound maxBound maxBound maxBound
    SDL.surfaceFillRect screenSurface Nothing white
    SDL.updateWindowSurface window
    SDL.delay 2000
    putTextLn "done"
