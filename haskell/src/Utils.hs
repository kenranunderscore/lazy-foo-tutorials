module Utils where

import           Relude

import qualified Control.Exception as Exception
import           Data.Text         (Text)
import qualified Data.Text         as Text
import qualified SDL

withSdl :: [SDL.InitFlag] -> IO a -> IO a
withSdl flags = Exception.bracket_
  (putTextLn "Initializing SDL..." >> SDL.initialize flags)
  (putTextLn "Quitting SDL..." >> SDL.quit)

withWindow :: Text -> SDL.WindowConfig -> (SDL.Window -> IO a) -> IO a
withWindow title windowConfig = Exception.bracket
  (do
      putTextLn $ "Creating window '" <> title <> "'..."
      SDL.createWindow title windowConfig)
  (\window -> do
      putTextLn $ "Destroying window '" <> title <> "'..."
      SDL.destroyWindow window)

withWindowSurface :: SDL.Window -> (SDL.Surface -> IO a) -> IO a
withWindowSurface window = Exception.bracket
  (do
      putTextLn "Getting window surface..."
      SDL.getWindowSurface window)
  (\surface -> do
      putTextLn $ "Destroying window surface..."
      SDL.freeSurface surface)

withBitmapSurface :: FilePath -> (SDL.Surface -> IO a) -> IO a
withBitmapSurface path = Exception.bracket
  (do
      putTextLn $ "Loading bitmap surface '" <> toText path <> "'..."
      SDL.loadBMP path)
  (\surface -> do
      putTextLn $ "Destroying bitmap surface '" <> toText path <> "'..."
      SDL.freeSurface surface)
