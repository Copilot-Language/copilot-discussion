
module Main where

import Language.Copilot
import Copilot.Compile.C99

import Prelude hiding ((>), (<=), (&&), (>=))

cm :: Stream Int32
cm = extern "distance" Nothing


spec = do
  trigger "green"  (cm > 18) [arg cm]
  trigger "yellow" ((18 >= cm) && (cm > 6)) [arg cm]
  trigger "red"    (cm <= 6) [arg cm]

-- Compile the spec
main = reify spec >>= compile "backup_monitor"
