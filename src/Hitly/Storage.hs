import BasePrelude
import Data.Hashable (Hashable)
import Control.Monad.Free
import Control.Monad.Free.TH
import qualified STMContainers.Map as SC
import qualified Control.Concurrent.Async as Async
import qualified Data.Char as Char
import qualified Data.Text as Text

-- * Transactions
-------------------------

data TransactionF k v n where
  Insert :: v -> k -> n -> TransactionF k v n
  Delete :: k -> n -> TransactionF k v n
  Lookup :: k -> n -> TransactionF k v n
  deriving (Functor, Show)

type Transaction k v = Free (TransactionF k v)

-- * Interpreters
-------------------------

type Interpreter m =
  forall k v r. (Hashable k, Eq k) => m k v -> Transaction k v r -> STM r

specializedInterpreter :: Interpreter SC.Map
specializedInterpreter m =
  iterM $ \case
    Insert v k c -> SC.insert v k m >> c
    Delete k c   -> SC.delete k m >> c
    Lookup k c   -> SC.lookup k m >> c

