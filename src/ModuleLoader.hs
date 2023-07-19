-- | This module re-implements GHC.Driver.Plugins.loadExternalPlugins

{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
module ModuleLoader where

import GHC.Exts (addrToAny#, Ptr(..))
import GHCi.ObjLink

loadModule :: FilePath -> String -> IO a
loadModule fp symbol = do
  initObjLinker RetainCAFs

  {-
  -- load library (needs "a.out" compiled with -shared)
  loadDLL fp >>= \case
    Just err -> error err
    Nothing -> pure ()
  -}
  loadObj fp

  -- resolve objects
  resolveObjs >>= \case
    True -> pure ()
    False -> error "Unable to resolve objects"

  lookupSymbol symbol >>= \case
    Nothing -> error "Symbol not found"
    Just (Ptr addr) -> case addrToAny# addr of
      (# a #) -> pure a

unloadModule :: FilePath -> IO ()
unloadModule = unloadObj
