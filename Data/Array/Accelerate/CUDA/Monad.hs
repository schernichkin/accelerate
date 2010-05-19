-- This module defines a state monad which keeps track of the code generator
-- state, including the unique suffix used in the code generator.

module Data.Array.Accelerate.CUDA.Monad (
  CGIO, CGState(..), OperationMapValue(..)
) where

import Control.Monad.State
import Data.Map
import Foreign.Ptr
import System.Posix.Types

type CGIO = StateT CGState IO

data OperationMapValue
  = OperationValue
    { compilerPID :: ProcessID  -- the PID of the compiler
    , progName    :: String}     -- generated CUDA kernel name
  | MemoryEntry
    --{ hostPtr     :: WordPtr    -- host pointer pinned by CUDA driver API
    { devicePtr   :: WordPtr    -- device pointer
    , numUse      :: Int}
  deriving Show

data CGState = CGState
  { uniqueID         :: Int
  , dataTransferHtoD :: Int
  , mapMap           :: Map String  OperationMapValue
  , zipWithMap       :: Map String  OperationMapValue
  , foldMap          :: Map String  OperationMapValue
  , memMap           :: Map WordPtr OperationMapValue} -- accelerate array pointer is the key value
  deriving Show