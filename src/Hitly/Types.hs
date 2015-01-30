module Hitly.Types where

import BasePrelude
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Text
import Data.Aeson

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
