module Hitly.Map (
  appMap,
  mkMap,
  atomicIO,
  newLink,
  getLink,
  lookupLink,
  lookupLinkInfo
  ) where

import BasePrelude hiding (insert, lookup, delete)
import Control.Monad.IO.Class
import STMContainers.Map

import Hitly.Types


appMap :: STM AppMap
appMap = new

mkMap :: MonadIO m => m AppMap
mkMap = liftIO $ atomically $ appMap

atomicIO :: MonadIO m => STM a -> m a
atomicIO = liftIO . atomically

newLink :: (Hashable k, Eq k) => v -> k -> Map k v -> STM ()
newLink = insert

getLink :: (Hashable k, Eq k) => k -> Map k v -> STM (Maybe v)
getLink urlHash smap = lookup urlHash smap

lookupLinkInfo :: (Hashable k, Eq k) => k -> Map k v -> STM (Maybe v)
lookupLinkInfo = getLink

lookupLink :: (Hashable k, Eq k) => k -> Map k HitlyRequest -> STM (Maybe HitlyRequest)
lookupLink urlHash smap = do
  orig <- getLink urlHash smap
  case orig of
       Nothing -> return Nothing
       Just (HitlyRequest user' url' cnt') -> do
                   let ticked = HitlyRequest user' url' (cnt' + 1)
                   delete urlHash smap
                   insert ticked urlHash smap
                   return $ Just ticked
