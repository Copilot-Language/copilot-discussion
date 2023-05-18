
import Language.Copilot
import Copilot.Compile.C99

import qualified Prelude as P 

cm :: Stream Int32
cm = extern "distance" Nothing


spec = do
  trigger "out_of_range"  (cm > 18) [arg cm]

-- Compile the spec
main = reify spec >>= compile "sonar"
