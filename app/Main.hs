module Main where

import ModuleLoader qualified
import System.Directory qualified
import Control.Monad

main :: IO ()
main = do
  cwd <- System.Directory.getCurrentDirectory
  let modPath = cwd <> "/Test.o"
  forever do
    putStrLn $ "Loading: " <> modPath
    (f :: String -> IO ()) <- ModuleLoader.loadModule modPath "Test_maFonction_closure"
    f "Haskell"
    putStrLn $ "Press enter to try again"
    ModuleLoader.unloadModule modPath
    void $ getLine
