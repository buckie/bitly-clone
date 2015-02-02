{- LANGUAGE BangPatterns -}

module Hitly.Hash (mkHash) where

import BasePrelude

import Crypto.Hash.SHA1 (hashlazy)
import qualified Data.Text.Lazy.Encoding as TL
import qualified Data.Text.Lazy as T
import           Data.ByteString.Lazy.Builder
import           Data.ByteString.Lazy.Builder.ASCII
import qualified Data.ByteString.Char8 as S8

viaBuilder :: S8.ByteString -> T.Text
viaBuilder = TL.decodeUtf8 . toLazyByteString . byteStringHexFixed

mkHash :: [T.Text] -> T.Text
mkHash = viaBuilder . hashlazy . TL.encodeUtf8 . T.concat
