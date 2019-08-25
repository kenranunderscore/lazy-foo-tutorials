{-# LANGUAGE OverloadedStrings #-}
module Lesson01 where

import qualified SDL

main :: IO ()
main = do
  SDL.initialize [SDL.InitVideo]
  window <- SDL.createWindow "SDL Tutorial" SDL.defaultWindow
  SDL.showWindow window
  screenSurface <- SDL.getWindowSurface window
  let white = SDL.V4 maxBound maxBound maxBound maxBound
  SDL.surfaceFillRect screenSurface Nothing white
  SDL.updateWindowSurface window
  SDL.delay 2000
  SDL.freeSurface screenSurface
  SDL.destroyWindow window
  SDL.quit
  putStrLn "done!"
