module Hitly.Map (
  appMap,
  mkMap,
  atomicIO,
  newLink,
  getLink,
  getAndTickCounter
  ) where

import BasePrelude

import Hitly.Types

import STMContainers.Map as SC

import Control.Monad.IO.Class

appMap :: STM AppMap
appMap = SC.new

mkMap :: MonadIO m => m AppMap
mkMap = liftIO $ atomically $ appMap

atomicIO :: MonadIO m => STM a -> m a
atomicIO = liftIO . atomically

newLink :: (Hashable k, Eq k) => v -> k -> Map k v -> STM ()
newLink = SC.insert

getLink :: (Hashable k, Eq k) => k -> Map k v -> STM (Maybe v)
getLink urlHash smap = SC.lookup urlHash smap

getAndTickCounter :: (Hashable k, Eq k) => k -> Map k HitlyRequest -> STM (Maybe HitlyRequest)
getAndTickCounter urlHash smap = do
  orig <- getLink urlHash smap
  case orig of
       Nothing -> return Nothing
       Just (HitlyRequest user' url' cnt') -> do
                   let ticked = HitlyRequest user' url' (cnt' + 1)
                   SC.delete urlHash smap
                   SC.insert ticked urlHash smap
                   return $ Just ticked

