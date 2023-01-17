import Control.Concurrent
import Text.Printf
import System.IO

main = do
    hSetBuffering stdout NoBuffering
    m <- newEmptyMVar
    printf "kicking off delayed mvar population...\n"
    forkIO $ delayPutMVar m
    printf "reading the mvar...\n"
    r <- takeMVar m
    print r

delayPutMVar :: MVar Char -> IO ()
delayPutMVar m = do
    threadDelay 1000000
    putMVar m 'x'
