import Language.Copilot hiding (even)

import Prelude hiding (even, (++), (==), mod)

nats :: Stream Int32
nats = [1] ++ (nats + 1)

evenStream :: Stream Int32
evenStream = nats * 2  

even :: Stream Int32 -> Stream Bool
even 

spec = do 
 observer "nats" nats
 observer "evens" evenStream 
 observer "Even?" (even (nats + evenStream))  
