module Utils
  ( withSdl
  , withSdlImage
  , withWindow
  , withWindowSurface
  , withBitmapSurface
  , withOptimizedBitmapSurface
  , withRenderer
  , withTexture
  )
where

import           Relude

import           Control.Exception.Safe (MonadMask)
import qualified Control.Exception.Safe as Exception
import           Data.Text              (Text)
import qualified Data.Text              as Text
import qualified SDL
import qualified SDL.Image              as IMG

withSdl :: (MonadIO m, MonadMask m) => [SDL.InitFlag] -> m a -> m a
withSdl flags = Exception.bracket_
  (withMessage "Initializing SDL..." (SDL.initialize flags))
  (withMessage "Quitting SDL..." SDL.quit)

withWindow
  :: (MonadIO m, MonadMask m)
  => Text
  -> SDL.WindowConfig
  -> (SDL.Window -> m a)
  -> m a
withWindow title windowConfig = Exception.bracket
  (withMessage
   ("Creating window '" <> title <> "'...")
   (SDL.createWindow title windowConfig))
  (withMessage ("Destroying window '" <> title <> "'...") . SDL.destroyWindow)

withWindowSurface :: (MonadIO m, MonadMask m) => SDL.Window -> (SDL.Surface -> m a) -> m a
withWindowSurface window = Exception.bracket
  (withMessage "Getting window surface..." (SDL.getWindowSurface window))
  (withMessage "Destroying window surface..." . SDL.freeSurface)

withBitmapSurface :: (MonadIO m, MonadMask m) => FilePath -> (SDL.Surface -> m a) -> m a
withBitmapSurface path = Exception.bracket
  (withMessage ("Loading bitmap surface '" <> toText path <> "'...") (SDL.loadBMP path))
  (withMessage ("Destroying bitmap surface '" <> toText path <> "'...") . SDL.freeSurface)

withOptimizedBitmapSurface
  :: (MonadIO m, MonadMask m)
  => FilePath
  -> SDL.SurfacePixelFormat
  -> (SDL.Surface -> m a)
  -> m a
withOptimizedBitmapSurface path targetFormat = Exception.bracket
  (loadOptimizedBitmap path targetFormat)
  (withMessage ("Destroying optimized bitmap surface '" <> toText path <> "'...")
   . SDL.freeSurface)

loadOptimizedBitmap
  :: (MonadIO m, MonadMask m)
  => FilePath
  -> SDL.SurfacePixelFormat
  -> m SDL.Surface
loadOptimizedBitmap path targetFormat = do
  putTextLn $ "Loading bitmap surface '" <> toText path <> "' with optimization..."
  withBitmapSurface path (flip SDL.convertSurface targetFormat)

withMessage :: (MonadIO m) => Text -> m a -> m a
withMessage message action = do
  putTextLn message >> action

withSdlImage :: (MonadIO m, MonadMask m) => [IMG.InitFlag] -> m a -> m a
withSdlImage flags = Exception.bracket_
  (withMessage "Initializing SDL_Image..." (IMG.initialize flags))
  (withMessage "Quitting SDL_Image..." IMG.quit)

withRenderer
  :: (MonadIO m, MonadMask m)
  => SDL.Window
  -> SDL.RendererConfig
  -> (SDL.Renderer -> m a)
  -> m a
withRenderer window rendererConfig = Exception.bracket
  (withMessage "Creating renderer..." (SDL.createRenderer window (-1) rendererConfig))
  (withMessage "Destroying renderer..." . SDL.destroyRenderer)

withTexture
  :: (MonadIO m, MonadMask m)
  => SDL.Renderer
  -> FilePath
  -> (SDL.Texture -> m a)
  -> m a
withTexture renderer path = Exception.bracket
  (loadTexture renderer path)
  (withMessage ("Destroying texture '" <> toText path <> "'...") . SDL.destroyTexture)

loadTexture :: (MonadIO m) => SDL.Renderer -> FilePath -> m SDL.Texture
loadTexture renderer path =
  (withMessage
   ("Loading texture from '" <> toText path <> "'...)")
   (IMG.loadTexture renderer path))
