module Hitly.Server where

import BasePrelude

import Hitly.Types
import Hitly.Hash

import STMContainers.Map as SC

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
import qualified Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html.Renderer.Text (renderHtml)

import Control.Monad.IO.Class
import qualified Data.Text.Lazy as T

runserver :: IO ()
runserver = scotty 3000 $ do
    middleware logStdoutDev
    middleware static
    shortenedMap <- liftIO $ atomically $ (SC.new :: STM (SC.Map T.Text HitlyRequest))

    get "/" $ do
        html $ renderHtml
             $ H.html $ do
                H.body $ do
                    H.form H.! method "post" H.! action "/create-link" $ do
                        H.input H.! type_ "text" H.! name "username"
                        H.input H.! type_ "text" H.! name "url"
                        H.input H.! type_ "submit"

    post "/create-link" $ do
        longUrl <- param "url"
        userName <- param "username"
        let hRequest = HitlyRequest userName longUrl 0
        let hash = mkHash [longUrl, userName]
        liftIO $ atomically $ SC.insert hRequest hash shortenedMap
        redirect $ T.concat ["/info/", hash]

    get "/:hash" $ do
        hash <- param "hash"
        check <- liftIO $ atomically $ SC.lookup hash shortenedMap
        case check of
            Nothing -> raise $ mconcat ["URL hash #", T.pack $ show $ hash, " not found in database!"]
            Just (HitlyRequest _ url _) -> redirect $ url

    -- We put /list down here to show that it will not match the '/:hash' route above.
    get "/info/:hash" $ do
        hash <- param "hash"
        check <- liftIO $ atomically $ SC.lookup hash shortenedMap
        case check of
            Nothing -> raise $ mconcat ["URL hash #", T.pack $ show $ hash, " not found in database!"]
            Just x -> json $ x

