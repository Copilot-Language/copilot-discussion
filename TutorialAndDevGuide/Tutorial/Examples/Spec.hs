import Language.Copilot 

import qualified Prelude as P

nats :: Stream Int32
nats = [0] ++ (1 + nats)

evenNumberNumber :: Stream Int32 -> Stream Bool
evenNumber n = n `mod` 2 == 0

oddNumber :: Stream Int32 -> Stream Bool
oddNumber n2 = n2 `mod` 2 == 1

difEvens  :: Stream Int32
difEvens = nats - ([0] ++ nats)
 
spec = do
  trigger "trigger1" (evenNumber nats) [arg nats, arg (oddNumber nats)]
  trigger "trigger2" (oddNumber nats) [arg nats]
