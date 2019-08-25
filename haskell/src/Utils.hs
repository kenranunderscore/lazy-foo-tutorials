module Utils
  ( withSdl
  , withWindow
  , withWindowSurface
  , withBitmapSurface
  , withOptimizedBitmapSurface
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

withOptimizedBitmapSurface :: FilePath -> SDL.SurfacePixelFormat -> (SDL.Surface -> IO a) -> IO a
withOptimizedBitmapSurface path targetFormat = Exception.bracket
  (loadOptimizedBitmap path targetFormat)
  (withMessage ("Destroying optimized bitmap surface '" <> toText path <> "'...") . SDL.freeSurface)

loadOptimizedBitmap :: FilePath -> SDL.SurfacePixelFormat -> IO SDL.Surface
loadOptimizedBitmap path targetFormat = do
  putTextLn $ "Loading bitmap surface '" <> toText path <> "' with optimization..."
  withBitmapSurface path (flip SDL.convertSurface targetFormat)

withMessage :: Text -> IO a -> IO a
withMessage message action = do
  putTextLn message >> action
