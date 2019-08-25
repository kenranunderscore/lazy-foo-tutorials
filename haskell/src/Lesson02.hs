{-# LANGUAGE OverloadedStrings #-}
module Lesson02 where

import qualified SDL
import qualified Utils

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial" SDL.defaultWindow $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface ->
    Utils.withBitmapSurface "../resources/hello_world.bmp" $ \helloWorld -> do
    SDL.surfaceBlit helloWorld Nothing screenSurface Nothing
    SDL.updateWindowSurface window
    SDL.delay 2000
    putStrLn "done!"
