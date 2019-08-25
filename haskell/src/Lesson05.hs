{-# LANGUAGE LambdaCase #-}
module Lesson05 where

import           Relude

import qualified SDL
import qualified Utils

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 640 480 }

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 05" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface -> do
    targetFormat <- SDL.surfaceFormat screenSurface
    Utils.withOptimizedBitmapSurface "../resources/stretch.bmp" targetFormat $ \stretchedSurface ->
      let loop = do
            eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
            let quit = SDL.QuitEvent `elem` eventPayloads
            SDL.surfaceBlitScaled stretchedSurface Nothing screenSurface Nothing
            SDL.updateWindowSurface window
            unless quit loop
      in loop
