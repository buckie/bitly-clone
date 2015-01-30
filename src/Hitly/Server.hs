{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Hitly.Server where

import Hitly.Hash
import Hitly.Types ()

import Web.Scotty

runServer :: IO ()
runServer = scotty 3000 $ do
  get "/" $ do
    html "Hello World"
  get "/create-link/:url" $ do
    submited_url <- param "url"
    let y = createReturn submited_url
    json (y)
