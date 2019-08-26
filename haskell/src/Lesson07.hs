module Lesson07 where

import           Relude

import           SDL       (($=))
import qualified SDL
import qualified SDL.Image as IMG
import qualified Utils

windowConfig :: SDL.WindowConfig
windowConfig = SDL.defaultWindow { SDL.windowInitialSize = SDL.V2 640 480 }

main :: IO ()
main =
  Utils.withSdl [SDL.InitVideo] $
  Utils.withSdlImage [IMG.InitPNG] $
  Utils.withWindow "SDL Tutorial: Lesson 07" windowConfig $ \window -> do
  SDL.showWindow window
  Utils.withRenderer window SDL.RendererConfig
    { SDL.rendererType = SDL.AcceleratedRenderer
    , SDL.rendererTargetTexture = False
    } $ \renderer -> do
    SDL.rendererDrawColor renderer $= (SDL.V4 maxBound maxBound maxBound maxBound)
    Utils.withTexture renderer "../resources/texture.png" $ \texture ->
      let loop = do
            eventPayloads <- map SDL.eventPayload <$> SDL.pollEvents
            let quit = SDL.QuitEvent `elem` eventPayloads
            SDL.clear renderer
            SDL.copy renderer texture Nothing Nothing
            SDL.present renderer
            unless quit loop
      in loop
