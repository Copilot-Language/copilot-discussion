import Language.Copilot

import Prelude hiding ((++), (==), mod, drop, not)

fib :: Stream Int32 
fib = [0,1,1] ++ ((drop 1 fib) + (drop 2 fib))

resetStream :: Stream Bool
resetStream = 0 == (fib `mod` 4)

incStream :: Stream Bool
incStream =  [False, True, False, True, False, True] ++ incStream

counter :: Stream Bool -> Stream Bool -> Stream Int32
counter inc reset = cnt
       where
       cnt = mux reset 0 (mux inc (z + 1) z)
       z = [0] ++ cnt

spec = do 
 observer "inc"   incStream
 observer "reset" resetStream
 observer "counter" (counter incStream resetStream) 
