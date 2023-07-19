-- | This module re-implements GHC.Driver.Plugins.loadExternalPlugins

{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
module ModuleLoader where

import GHCi.ObjLink (ShouldRetainCAFs(RetainCAFs), initObjLinker, loadDLL, resolveObjs, lookupSymbol)
import GHC.Exts (addrToAny#, Ptr(..))

loadModule :: FilePath -> String -> IO a
loadModule fp symbol = do
  initObjLinker RetainCAFs

  -- load library
  loadDLL fp >>= \case
    Just err -> error err
    Nothing -> pure ()

  -- resolve objects
  resolveObjs >>= \case
    True -> pure ()
    False -> error "Unable to resolve objects"

  lookupSymbol symbol >>= \case
    Nothing -> error "Symbol not found"
    Just (Ptr addr) -> case addrToAny# addr of
      (# a #) -> pure a
