{-# LANGUAGE LambdaCase #-}
module Lesson04 where

import           Relude

import qualified SDL
import qualified Utils

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 640 480 }

withImages :: (SDL.Surface -> SDL.Surface -> SDL.Surface -> SDL.Surface -> SDL.Surface -> IO a) -> IO a
withImages action =
  Utils.withBitmapSurface "../resources/press.bmp" $ \press ->
  Utils.withBitmapSurface "../resources/up.bmp" $ \up ->
  Utils.withBitmapSurface "../resources/down.bmp" $ \down ->
  Utils.withBitmapSurface "../resources/left.bmp" $ \left ->
  Utils.withBitmapSurface "../resources/right.bmp" $ \right ->
  action press up down left right

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 04" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withWindowSurface window $ \screenSurface ->
    withImages $ \press up down left right -> do
    let loop currentSurface = do
          eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
          let quit = SDL.QuitEvent `elem` eventPayloads
              nextSurface = fromMaybe currentSurface $ getLast $
                foldMap (\case SDL.KeyboardEvent e
                                 | SDL.keyboardEventKeyMotion e == SDL.Pressed ->
                                   case SDL.keysymKeycode (SDL.keyboardEventKeysym e) of
                                     SDL.KeycodeUp -> Last (Just up)
                                     SDL.KeycodeDown -> Last (Just down)
                                     SDL.KeycodeLeft -> Last (Just left)
                                     SDL.KeycodeRight -> Last (Just right)
                                     _ -> mempty
                               _ -> mempty)
                eventPayloads
          SDL.surfaceBlit nextSurface Nothing screenSurface Nothing
          SDL.updateWindowSurface window
          unless quit (loop nextSurface)
      in loop press
