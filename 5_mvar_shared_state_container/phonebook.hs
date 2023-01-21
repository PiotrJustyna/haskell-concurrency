import Data.Map
import Control.Concurrent

type Name = String
type PhoneNumber = String
type PhoneBook = Map Name PhoneNumber

newtype PhoneBookState = PhoneBookState (MVar PhoneBook)

new :: IO PhoneBookState
new = do
    m <- newMVar Map.empty
    return (PhoneBookState m)

insert :: PhoneBookState -> Name -> PhoneNumber -> IO ()
insert (PhoneBookState m) name number = do
    phoneBook <- takeMVar m
    let newPhoneBook = Map.insert name number phoneBook
    putMVar m newPhoneBook

lookup :: PhoneBookState -> Name -> IO (Maybe PhoneNumber)
lookup (PhoneBookState m) name = do
    phoneBook <- takeMVar m
    putMVar m phoneBook
    return (Map.lookup name phoneBook)

main = do
    state <- new
    sequence_ [insert state ("name" ++ show n) (show n) | n <- [1..10000]]
    lookup state "name999" >>= print
    lookup state "unknown" >>= print