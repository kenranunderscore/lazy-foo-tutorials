module Lesson03 where

import           Relude

import qualified SDL
import qualified Utils

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 03" SDL.defaultWindow $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface ->
    Utils.withBitmapSurface "../resources/x.bmp" $ \x ->
    let
      loop = do
        eventPayloads <- SDL.pollEvents >>= (return . map SDL.eventPayload)
        let quit = elem SDL.QuitEvent eventPayloads
        SDL.surfaceBlit x Nothing screenSurface Nothing
        SDL.updateWindowSurface window
        unless quit loop
    in loop
