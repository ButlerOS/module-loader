module Main where

import ModuleLoader (loadModule)
import System.Directory qualified

main :: IO ()
main = do
  cwd <- System.Directory.getCurrentDirectory
  let modPath = cwd <> "/a.out"
  putStrLn $ "Loading: " <> modPath
  (f :: String -> IO ()) <- loadModule modPath "Test_maFonction_closure"
  f "Haskell"
