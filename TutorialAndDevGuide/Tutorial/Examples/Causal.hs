import Language.Copilot

import Prelude hiding (drop, (++))

fib :: Stream Int32
fib = [0, 1, 1] ++ ((drop 1 fib) + (drop 2 fib))

fastForwardFib :: Stream Int32
fastForwardFib = drop 1 fib

delayFib :: Stream Int32
delayFib = [0] ++ fib

causal = do
 observer "Fibonacci" fib
 observer "Leading"   fastForwardFib
 observer "Lagging"   delayFib
