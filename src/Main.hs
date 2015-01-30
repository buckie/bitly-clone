module Main where

-- import System.Environment (getArgs)

import Hitly.Server
import Hitly.Types
import Hitly.Hash
-- main :: IO ()
-- main = do args <- getArgs
--           case length args of
--                1 ->  SL8.putStrLn $ mkLink $ args !! 0
--                _ ->  error "Program takes only 0 or 1 argument"

main = runServer
