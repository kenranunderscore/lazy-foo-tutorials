{-# LANGUAGE OverloadedStrings #-}
module Lesson01 where

import qualified SDL
import qualified Utils

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial" SDL.defaultWindow $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface -> do
    let white = SDL.V4 maxBound maxBound maxBound maxBound
    SDL.surfaceFillRect screenSurface Nothing white
    SDL.updateWindowSurface window
    SDL.delay 2000
    putStrLn "done"
