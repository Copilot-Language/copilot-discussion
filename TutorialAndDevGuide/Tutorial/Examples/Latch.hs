import Language.Copilot

import Prelude hiding ((++), (==), mod, drop, not)

fib :: Stream Int32 
fib = [0,1,1] ++ ((drop 1 fib) + (drop 2 fib))

boolStream:: Stream Bool
boolStream = 0 == (fib `mod` 4)

latch :: Stream Bool -> Stream Bool 
latch x = y
          where 
          y = mux x (not z) z
          z = [False] ++ y 

spec = do 
 observer "x" boolStream
 observer "y" (latch boolStream) 
