module Hitly.Types where

import BasePrelude
import Data.ByteString.Char8 (ByteString)
import Data.Text
import Data.Aeson

type Hash = ByteString

data HitlyRequest = HitlyRequest {
                        user :: !ByteString,
                        url  :: !ByteString
                      } deriving (Show, Generic)

data HitlyReturn = HitlyReturn {
                        shorturl  :: !Text
                      } deriving (Show, Generic)

instance FromJSON HitlyReturn
instance ToJSON HitlyReturn
