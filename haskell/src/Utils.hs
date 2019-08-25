module Utils
  ( withSdl
  , withWindow
  , withWindowSurface
  , withBitmapSurface
  )
where

import           Relude

import qualified Control.Exception as Exception
import           Data.Text         (Text)
import qualified Data.Text         as Text
import qualified SDL

withSdl :: [SDL.InitFlag] -> IO a -> IO a
withSdl flags = Exception.bracket_
  (withMessage "Initializing SDL..." (SDL.initialize flags))
  (withMessage "Quitting SDL..." SDL.quit)

withWindow :: Text -> SDL.WindowConfig -> (SDL.Window -> IO a) -> IO a
withWindow title windowConfig = Exception.bracket
  (withMessage ("Creating window '" <> title <> "'...") (SDL.createWindow title windowConfig))
  (withMessage ("Destroying window '" <> title <> "'...") . SDL.destroyWindow)

withWindowSurface :: SDL.Window -> (SDL.Surface -> IO a) -> IO a
withWindowSurface window = Exception.bracket
  (withMessage "Getting window surface..." (SDL.getWindowSurface window))
  (withMessage "Destroying window surface..." . SDL.freeSurface)

withBitmapSurface :: FilePath -> (SDL.Surface -> IO a) -> IO a
withBitmapSurface path = Exception.bracket
  (withMessage ("Loading bitmap surface '" <> toText path <> "'...") (SDL.loadBMP path))
  (withMessage ("Destroying bitmap surface '" <> toText path <> "'...") . SDL.freeSurface)

withMessage :: Text -> IO a -> IO a
withMessage message action = do
  putTextLn message >> action
