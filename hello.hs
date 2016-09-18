module Hello where

hello :: String -> IO ()
hello x = putStrLn ("Hello, " ++ x ++ "!")
