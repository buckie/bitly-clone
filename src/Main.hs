module Main where

import qualified Crypto.Hash.SHA256 as SHA

import qualified Data.ByteString      as S
import qualified Data.ByteString.Lazy as L
import           Data.ByteString.Lazy.Builder
import           Data.ByteString.Lazy.Builder.ASCII
import qualified Data.ByteString.Char8 as S8
import qualified Data.ByteString.Lazy.Char8 as SL8
import System.Environment (getArgs)

viaBuilder :: S.ByteString -> L.ByteString
viaBuilder = toLazyByteString . byteStringHexFixed

mkLink :: String -> SL8.ByteString
mkLink = viaBuilder . SHA.hash . S8.pack

main :: IO ()
main = do args <- getArgs
          case length args of
               1 ->  SL8.putStrLn $ mkLink $ args !! 0
               _ ->  error "Program takes only 0 or 1 argument"


