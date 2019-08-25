{-# LANGUAGE OverloadedStrings #-}
module Utils where

import qualified Control.Exception as Exception
import           Data.Text         (Text)
import qualified Data.Text         as Text
import qualified SDL

withSdl :: [SDL.InitFlag] -> IO a -> IO a
withSdl flags = Exception.bracket_
  (putStrLn "Initializing SDL..." >> SDL.initialize flags)
  (putStrLn "Quitting SDL..." >> SDL.quit)

withWindow :: Text -> SDL.WindowConfig -> (SDL.Window -> IO a) -> IO a
withWindow title windowConfig =
  let title' = "'" ++ Text.unpack title ++ "'"
  in Exception.bracket
     (do
         putStrLn $ "Creating window " ++ title' ++ "..."
         SDL.createWindow title windowConfig)
     (\window -> do
         putStrLn $ "Destroying window " ++ title' ++ "..."
         SDL.destroyWindow window)

withWindowSurface :: SDL.Window -> (SDL.Surface -> IO a) -> IO a
withWindowSurface window = Exception.bracket
  (do
      putStrLn "Getting window surface..."
      SDL.getWindowSurface window)
  (\surface -> do
      putStrLn $ "Destroying window surface..."
      SDL.freeSurface surface)

withBitmapSurface :: FilePath -> (SDL.Surface -> IO a) -> IO a
withBitmapSurface path = Exception.bracket
  (do
      putStrLn $ "Loading bitmap surface '" ++ path ++ "'..."
      SDL.loadBMP path)
  (\surface -> do
      putStrLn $ "Destroying bitmap surface '" ++ path ++ "'..."
      SDL.freeSurface surface)
