module Hitly.Server where

import BasePrelude

import Hitly.Hash
import Hitly.Types

import Web.Scotty

runServer :: IO ()
runServer = scotty 3000 $ do
  get "/" $ do
    html "Hello World"
  get "/create-link/:url" $ do
    submitedURL <- param "url"
    userName <- param "user"
    let hitlyRequest = HitlyRequest userName submitedURL
    let y = createReturn hitlyRequest
    json (y)
