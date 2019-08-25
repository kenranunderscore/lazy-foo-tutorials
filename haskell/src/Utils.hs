module Utils where

import qualified SDL
import Data.Text (Text)
import qualified Control.Exception as Exception

withSdl :: [SDL.InitFlag] -> IO a -> IO a
withSdl flags = Exception.bracket_
  (SDL.initialize flags)
  SDL.quit

withWindow :: Text -> SDL.WindowConfig -> (SDL.Window -> IO a) -> IO a
withWindow title windowConfig = Exception.bracket
  (SDL.createWindow title windowConfig)
  SDL.destroyWindow

withWindowSurface :: SDL.Window -> (SDL.Surface -> IO a) -> IO a
withWindowSurface window = Exception.bracket
  (SDL.getWindowSurface window)
  SDL.freeSurface
