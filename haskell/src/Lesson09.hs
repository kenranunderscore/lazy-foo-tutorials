module Lesson09 where

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
  Utils.withWindow "SDL Tutorial: Lesson 09" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withRenderer window SDL.RendererConfig
    { SDL.rendererType = SDL.AcceleratedRenderer
    , SDL.rendererTargetTexture = False
    } $ \renderer ->
    Utils.withTexture renderer "../resources/viewport.png" $ \texture ->
    let loop = do
          eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
          let quit = SDL.QuitEvent `elem` eventPayloads

          draw renderer texture

          SDL.present renderer
          unless quit loop
    in loop

draw :: SDL.Renderer -> SDL.Texture -> IO ()
draw renderer texture = do
  SDL.rendererDrawColor renderer $= (SDL.V4 maxBound maxBound maxBound maxBound)
  SDL.clear renderer
  let topLeftViewport = SDL.Rectangle (SDL.P (SDL.V2 0 0)) (SDL.V2 (screenWidth `div` 2) (screenHeight `div` 2))
  SDL.rendererViewport renderer $= Just topLeftViewport
  SDL.copy renderer texture Nothing Nothing
  let topRightViewport = SDL.Rectangle (SDL.P (SDL.V2 (screenWidth `div` 2) 0)) (SDL.V2 (screenWidth `div` 2) (screenHeight `div` 2))
  SDL.rendererViewport renderer $= Just topRightViewport
  SDL.copy renderer texture Nothing Nothing
  let bottomViewport = SDL.Rectangle (SDL.P (SDL.V2 0 (screenHeight `div` 2))) (SDL.V2 screenWidth (screenHeight `div` 2))
  SDL.rendererViewport renderer $= Just bottomViewport
  SDL.copy renderer texture Nothing Nothing
