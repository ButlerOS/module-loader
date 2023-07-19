-- | A test module to be loaded dynamically
module Test where

maFonction :: String -> IO ()
maFonction s = putStrLn $ "Hello " <> s
