divert(-1)
changequote({,})
define({LQ},{changequote(`,'){dnl}
changequote({,})})
define({RQ},{changequote(`,')dnl{
}changequote({,})})
changecom({--})


divert(0)dnl
import Copilot.Language.Reify
import Copilot.Language
import Copilot.Language.Operators.Eq
import Copilot.Library.Clocks

import qualified Copilot.Compile.SBV as S
import qualified Copilot.Compile.C99 as C
import qualified Prelude as P
import Debug.Trace
import Control.Monad (foldM_)

--------------------------------------------------------------------------------
-- NEVER USE THIS PIECE OF CODE FOR WRITING A REAL MONITOR (cf ARIANE 5 fail)
-- Implementation of http://shemesh.larc.nasa.gov/people/cam/publications/NASA-TM-2014-218280.pdf
--------------------------------------------------------------------------------

import qualified Data.List as L

-----------------------------------------
-- Spec
-----------------------------------------

alt :: Stream Bool
alt = (label "?splitting" $ not $ externB "externvar" Nothing)



spec :: Spec
spec = do
--  trigger "alert_WCVtau" (wellClearViolation tau relPositionX relPositionY relPositionZ relVelocityX relVelocityY relVelocityZ) []
--  trigger "alert_WCVtcpa" (wellClearViolation tcpa relPositionX relPositionY relPositionZ relVelocityX relVelocityY relVelocityZ) []
--  trigger "alert_WCVtaumod" (wellClearViolation taumod relPositionX relPositionY relPositionZ relVelocityX relVelocityY relVelocityZ) []
--  trigger "alert_WCVtep" (wellClearViolation tep relPositionX relPositionY relPositionZ relVelocityX relVelocityY relVelocityZ) []
  trigger "trigger" (alt) []


main = do
   reify spec >>= S.proofACSL S.defaultParams


--------------------------------------------------------------------------------