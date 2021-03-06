module Hitly.Types (
  Hashable,
  Hash,
  AppMap,
  HitlyRequest(..),
  HitlyReturn(..)
  )
  where

import BasePrelude
import Data.ByteString.Char8 (ByteString)
import Data.Text.Lazy
import Data.Aeson
import Data.Hashable (Hashable)
import qualified STMContainers.Map as SC

type AppMap = SC.Map Text HitlyRequest

type Hash = ByteString

data HitlyRequest = HitlyRequest {
                        user :: !Text,
                        url  :: !Text,
                        hitCount :: Int
                      } deriving (Show, Generic)

instance Hashable HitlyRequest
instance ToJSON HitlyRequest
instance FromJSON HitlyRequest

data HitlyReturn = HitlyReturn {
                        shorturl  :: !Text
                      } deriving (Show, Generic)

instance FromJSON HitlyReturn
instance ToJSON HitlyReturn
