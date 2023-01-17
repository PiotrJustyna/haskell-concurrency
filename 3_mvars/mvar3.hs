import Control.Concurrent

main = do
    m <- newEmptyMVar
    takeMVar m

-- 2023-01-17 PJ:
-- --------------
-- Deadlock automatically detected, main thread terminated with an exception:
-- mvar3: thread blocked indefinitely in an MVar operation