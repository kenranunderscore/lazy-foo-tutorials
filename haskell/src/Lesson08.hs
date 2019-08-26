module Lesson08 where

import           Relude

import           Foreign.C.Types (CInt)
import           SDL             (($=))
import qualified SDL
import qualified SDL.Image       as IMG
import qualified Utils

screenWidth, screenHeight :: CInt
(screenWidth, screenHeight) = (640, 480)

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 screenWidth screenHeight }

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withWindow "SDL Tutorial: Lesson 08" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withRenderer window SDL.RendererConfig
    { SDL.rendererType = SDL.AcceleratedRenderer
    , SDL.rendererTargetTexture = False
    } $ \renderer ->
    let loop = do
          eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
          let quit = SDL.QuitEvent `elem` eventPayloads

          drawForms renderer

          SDL.present renderer
          unless quit loop
    in loop

drawForms :: SDL.Renderer -> IO ()
drawForms renderer = do
  SDL.rendererDrawColor renderer $= (SDL.V4 maxBound maxBound maxBound maxBound)
  SDL.clear renderer
  SDL.rendererDrawColor renderer $= (SDL.V4 maxBound 0 0 maxBound)
  SDL.fillRect renderer
    (Just $ SDL.Rectangle
      (SDL.P (SDL.V2 (screenWidth `div` 4) (screenHeight `div` 4)))
      (SDL.V2 (screenWidth `div` 2) (screenHeight `div` 2)))
  SDL.rendererDrawColor renderer $= (SDL.V4 0 maxBound 0 maxBound)
  SDL.drawRect renderer
    (Just $ SDL.Rectangle
      (SDL.P (SDL.V2 (screenWidth `div` 6) (screenHeight `div` 6)))
      (SDL.V2 (screenWidth * 2 `div` 3) (screenHeight * 2 `div` 3)))
  SDL.rendererDrawColor renderer $= (SDL.V4 0 0 maxBound maxBound)
  SDL.drawLine renderer
    (SDL.P (SDL.V2 0 (screenHeight `div` 2))) (SDL.P (SDL.V2 screenWidth (screenHeight `div` 2)))
  SDL.rendererDrawColor renderer $= (SDL.V4 maxBound maxBound 0 maxBound)
  for_ [0, 4 .. screenHeight] $ \index ->
    SDL.drawPoint renderer (SDL.P (SDL.V2 (screenWidth `div` 2) index))
