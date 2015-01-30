{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Hitly.Types where

import Data.ByteString.Lazy.Char8 (ByteString)
-- import qualified Data.ByteString.Char8 as S8
import Data.Text
import Data.Aeson
import GHC.Generics

type Hash = ByteString

data HitlyRequest = HitlyRequest {
                        user :: !Text,
                        url  :: !Text
                      } deriving (Show, Generic)

instance FromJSON HitlyRequest
instance ToJSON HitlyRequest

data HitlyReturn = HitlyReturn {
                        shorturl  :: !Text
                      } deriving (Show, Generic)

instance FromJSON HitlyReturn
instance ToJSON HitlyReturn
