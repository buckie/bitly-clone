module Hitly.Server where

import BasePrelude

import Hitly.Types
import Hitly.Hash
import Hitly.Map

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static

import qualified Data.Text.Lazy as T

runserver :: IO ()
runserver = scotty 3000 $ do

    middleware logStdoutDev
    middleware $ staticPolicy (noDots >-> addBase "static")
    shortenedMap <- mkMap

    get "/" $ do
        file "index.html"

    post "/create-link" $ do
        longUrl <- param "url"
        userName <- param "username"
        let hRequest = HitlyRequest userName longUrl 0
        let hash = mkHash [longUrl, userName]
        atomicIO $ newLink hRequest hash shortenedMap
        redirect $ T.concat ["/info/", hash]

    get "/info/:hash" $ do
        hash <- param "hash"
        check <- atomicIO $ lookupLinkInfo hash shortenedMap
        case check of
            Nothing -> raise $ mconcat ["URL hash #", T.pack $ show $ hash, " not found in database!"]
            Just x  -> json $ x

    get "/:hash" $ do
        hash <- param "hash"
        check <- atomicIO $ lookupLink hash shortenedMap
        case check of
            Just (HitlyRequest _ url _) -> redirect $ url
            Nothing                     -> raise $ mconcat ["URL hash #", T.pack $ show $ hash, " not found in database!"]


