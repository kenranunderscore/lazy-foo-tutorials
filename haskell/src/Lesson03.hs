module Lesson03 where

import           Relude

import qualified SDL
import qualified Utils

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 640 480 }

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 03" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface ->
    Utils.withBitmapSurface "../resources/x.bmp" $ \x ->
    let
      loop = do
        eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
        let quit = elem SDL.QuitEvent eventPayloads
        SDL.surfaceBlit x Nothing screenSurface Nothing
        SDL.updateWindowSurface window
        unless quit loop
    in loop
