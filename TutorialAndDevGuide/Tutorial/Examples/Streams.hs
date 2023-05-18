import Language.Copilot

import qualified Prelude as P

x :: Stream Int32
x = 5 + 5

y :: Stream Int32
y = x * x

z :: Stream Bool
z = x == 10 && y < 200

printStreams = do 
  observer "x" x
  observer "y" y 
  observer "z" z
