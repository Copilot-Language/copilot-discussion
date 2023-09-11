{-#LANGUAGE DataKinds #-}

module Struct where

import Language.Copilot

import Prelude hiding ((>), (<), div, (++))

data Vec = Vec
  { x :: Field "x" Float
  , y :: Field "y" Float}

instance Struct Vec where
  typename _ = "vec" -- Name of the type in C

toValues :: Vec -> [Value Vec]
toValues v = [ Value Float (x v)
             , Value Float (y v)]

-- We need to provide an instance to Typed with a bogus Vec
instance Typed Vec where
  typeOf = Struct (Vec (Field 0) (Field 0))

vecs :: Stream Vec
vecs = [ Vec (Field 1) (Field 2)
       , Vec (Field 12) (Field 8)] ++ vecs


-- Trigger that always executes, splits the vec into seperate args.
spec = do
  observer "split x" (vecs # x) 
  observer "split y" (vecs # y)
