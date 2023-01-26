module GetUrls1
    ( getUrls
    ) where

import Control.Concurrent
import Data.ByteString as B
import GetURL

getUrls :: IO ()
getUrls = do
    m1 <- newEmptyMVar
    m2 <- newEmptyMVar

    _ <- forkIO $ do
        r <- getURL "http://www.wikipedia.org/wiki/Shovel"
        putMVar m1 r

    _ <- forkIO $ do
        r <- getURL "http://www.wikipedia.org/wiki/Spade"
        putMVar m2 r

    r1 <- takeMVar m1
    r2 <- takeMVar m2

    print (B.length r1, B.length r2)