import Control.Concurrent

data Logger = Logger (MVar LogCommand)

data LogCommand = Message String | Stop (MVar ())

initLogger :: IO Logger
initLogger = do
    m <- newEmptyMVar
    let l = Logger m
    forkIO (loggerLoop l)
    return l

loggerLoop  :: Logger -> IO ()
loggerLoop (Logger m) = loop
    where
        loop = do
            cmd <- takeMVar m
            case cmd of
                Message x -> do
                    putStrLn x
                    loop
                Stop s -> do
                    putStrLn "loggerLoop: stop"
                    putMVar s ()

logMessage :: Logger -> String -> IO ()
logMessage (Logger m) msg = do
    putMVar m (Message msg)

logStop :: Logger -> IO ()
logStop (Logger m) = do
    emptyMvar <- newEmptyMVar
    forkIO (putMVar m (Stop emptyMvar))
    takeMVar emptyMvar

main = do
    l <- initLogger
    logMessage l "hello"
    logMessage l "bye"
    logStop l

-- 2023-01-19 PJ:
-- --------------
-- reads:
-- hello
-- bye
-- loggerLoop: stop