module Lesson02 where

import           Relude

import qualified SDL
import qualified Utils

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 640 480 }

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 02" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface ->
    Utils.withBitmapSurface "../resources/hello_world.bmp" $ \helloWorld -> do
    SDL.surfaceBlit helloWorld Nothing screenSurface Nothing
    SDL.updateWindowSurface window
    SDL.delay 2000
    putTextLn "done!"
