
import Language.Copilot
import Copilot.Compile.C99

import qualified Prelude as P 

cm :: Stream Int32
cm = extern "distance" Nothing

lowerBound :: Stream Int32 -> Stream Int32 -> Stream Bool
lowerBound value low = low < value
  
bounds :: Stream Int32 -> Stream Int32 -> Stream Int32 -> Stream Bool 
bounds value low high = low < value && value < high 

upperBound :: Stream Int32 -> Stream Int32 -> Stream Bool
upperBound value high = value < high

spec = do
  trigger "low_range"  (lowerBound cm 10) [arg cm]
  trigger "out_of_bounds" (bounds cm 10 18) [arg cm]
  trigger "upper_bound"   (upperBound cm 18) [arg cm]

-- Compile the spec
main = reify spec >>= compile "sonar"
