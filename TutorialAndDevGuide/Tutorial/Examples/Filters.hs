import Language.Copilot

import Prelude hiding (drop, (++), div )

fib :: Stream Int32
fib = [0,1,1] ++ (drop 1 fib + drop 2 fib)

fibdelayed :: Stream Int32
fibdelayed = [0] ++ fib

diff :: Stream Int32
diff = fib - fibdelayed

gain :: Stream Int32
gain = fib + 2 

twoTermAverage :: Stream Int32
twoTermAverage =  (fib + fibdelayed) `div` 2

centralDifference :: Stream Int32
centralDifference = (fib - ([0] ++ fibdelayed)) `div` 2

recursive :: Stream Int32
recursive = fib - diff

gainFilter = do 
  observer "fib" fib
  observer "Simple Gain" gain
 
diffFilter = do 
  observer "fib" fib
  observer "fib delayed" fibdelayed
  observer "Difference Filter" diff
  observer "Recursive Diff" recursive

pureDelay = do 
  observer "fib" fib
  observer "Pure Delay" fibdelayed

ttAverage = do
  observer "fib" fib
  observer "Two Term Average" twoTermAverage

cDiff = do 
  observer "fib" fib
  observer "Central Difference" centralDifference

