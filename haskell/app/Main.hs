module Main where

import           Relude

import qualified Lesson01
import qualified Lesson02
import qualified Lesson03

main :: IO ()
main = do
  Lesson01.main
  Lesson02.main
  Lesson03.main
