import Copilot.Language as Copilot
import Copilot.Library.MTL as MTL
import Copilot.Library.PTLTL as PTLTL
import Copilot.Language.Reify
import Copilot.Compile.C99
import Prelude ()

dist :: Word64
dist = 100000000

spec :: Spec
spec =
  do
    takeOffAltitudeViolation 180000000000 dist 5000
    maxAirspeedViolation 60000000000 dist
    afterBurnerOffTimeViolation 60000000000 dist
    stallWarningPitchViolation 60000000000 dist 

clk :: Stream Word64
clk = extern "clk_nanosec" Nothing

-- After Takeoff aircraft should achieve an altitude of alt = 5000 feet
-- in n = 3 min

-- Want to have property:
-- takeoff ==> eventually [0,n] (altitude >= ft)
-- Write instead as past property so it is suitable for monitoring:
-- not (since [n,n'] (alt < ft) takeoff)

takeOffAltitudeViolation :: Word64 -> Word64 -> Double -> Spec
takeOffAltitudeViolation amt dist alt =
  Copilot.trigger
  "takeoff_altitude_violation"
  (MTL.since amt (amt + dist - 1) clk dist (altitude < (constant alt)) takeoff)
  [(arg ((replicate 10 0.0) ++ altitude)), (arg ((replicate 10 0) ++ clk)),
   (arg ((replicate 9 0.0) ++ altitude)), (arg ((replicate 9 0) ++ clk)),
   (arg ((replicate 8 0.0) ++ altitude)), (arg ((replicate 8 0) ++ clk)),
   (arg ((replicate 7 0.0) ++ altitude)), (arg ((replicate 7 0) ++ clk)),
   (arg ((replicate 6 0.0) ++ altitude)), (arg ((replicate 6 0) ++ clk)),
   (arg ((replicate 5 0.0) ++ altitude)), (arg ((replicate 5 0) ++ clk)),
   (arg ((replicate 4 0.0) ++ altitude)), (arg ((replicate 4 0) ++ clk)),
   (arg ((replicate 3 0.0) ++ altitude)), (arg ((replicate 3 0) ++ clk)),
   (arg ((replicate 2 0.0) ++ altitude)), (arg ((replicate 2 0) ++ clk)),
   (arg ([0] ++ altitude)), (arg ([0] ++ clk)),
   arg altitude, arg clk,
   arg (constant alt)]

  where
   
  altitude :: Stream Double
  altitude = extern "altitude_ft" Nothing

  takeoff :: Stream Bool
  takeoff = extern "takeoff" Nothing

-- Given max airspeed MaxAS, do not exceed MaxAS for an amount of time
-- greater than or equal to n = 60 sec

-- Want to have property:
-- eventuallyPrev [0, n] (airspeed <= maxAS)

maxAirspeedViolation :: Word64 -> Word64 -> Spec
maxAirspeedViolation amt dist =
  Copilot.trigger
    "airspeed_violation"
    (not (MTL.eventuallyPrev 0 (amt) clk dist (airspeed <= maxAS)))
    [(arg ((replicate 10 0.0) ++ airspeed)), (arg ((replicate 10 0) ++ clk)),
     (arg ((replicate 9 0.0) ++ airspeed)), (arg ((replicate 9 0) ++ clk)),
     (arg ((replicate 8 0.0) ++ airspeed)), (arg ((replicate 8 0) ++ clk)),
     (arg ((replicate 7 0.0) ++ airspeed)), (arg ((replicate 7 0) ++ clk)),
     (arg ((replicate 6 0.0) ++ airspeed)), (arg ((replicate 6 0) ++ clk)),
     (arg ((replicate 5 0.0) ++ airspeed)), (arg ((replicate 5 0) ++ clk)),
     (arg ((replicate 4 0.0) ++ airspeed)), (arg ((replicate 4 0) ++ clk)),
     (arg ((replicate 3 0.0) ++ airspeed)), (arg ((replicate 3 0) ++ clk)),
     (arg ((replicate 2 0.0) ++ airspeed)), (arg ((replicate 2 0) ++ clk)),
     (arg ([0.0] ++ airspeed)), (arg ([0] ++ clk)),
     arg airspeed, arg clk, arg maxAS]
  
  where

  airspeed :: Stream Double
  airspeed = extern "airspeed" Nothing

  maxAS :: Stream Double
  maxAS = extern "max_airspeed" Nothing

-- If we transition from afterburner on to afterburner off, the
-- afterburner remains off for n = 60 sec

-- Want to have property:
-- afterburner && (next (not afterburner)) ==> not (eventually [0,n] afterburner)
-- Write instead as past property so it is suitable for monitoring:
-- afterburner ==> not (eventuallyPrev [0,n] ((not afterburner) && prev afterburner))

afterBurnerOffTimeViolation :: Word64 -> Word64 -> Spec
afterBurnerOffTimeViolation amt dist =
  Copilot.trigger
    "afterburner_violation"
    (not (afterburnerOn ==>
          not (MTL.eventuallyPrev 0 amt clk dist ((not afterburnerOn) && (previous afterburnerOn)))))
    [(arg ((replicate 10 False) ++ afterburnerOn)), (arg ((replicate 10 0) ++ clk)),
     (arg ((replicate 9 False) ++ afterburnerOn)), (arg ((replicate 9 0) ++ clk)),
     (arg ((replicate 8 False) ++ afterburnerOn)), (arg ((replicate 8 0) ++ clk)),
     (arg ((replicate 7 False) ++ afterburnerOn)), (arg ((replicate 7 0) ++ clk)),
     (arg ((replicate 6 False) ++ afterburnerOn)), (arg ((replicate 6 0) ++ clk)),
     (arg ((replicate 5 False) ++ afterburnerOn)), (arg ((replicate 5 0) ++ clk)),
     (arg ((replicate 4 False) ++ afterburnerOn)), (arg ((replicate 4 0) ++ clk)),
     (arg ((replicate 3 False) ++ afterburnerOn)), (arg ((replicate 3 0) ++ clk)),
     (arg ((replicate 2 False) ++ afterburnerOn)), (arg ((replicate 2 0) ++ clk)),
     (arg ([False] ++ afterburnerOn)), (arg ([0] ++ clk)),
     arg afterburnerOn, arg clk]

  where

  afterburnerOn :: Stream Bool
  afterburnerOn = extern "afterburner_on" Nothing

-- If the stall warning alarm is sounded, then the pitch should
-- be between 0 and 10 degrees within n = 60 sec

-- Want to have property:
-- stallWarning ==> (eventually [0,n] (0 <= pitch <= 10))
-- Write instead as past property so it is suitable for monitoring:
-- not (since [n,n'] (not (0 <= pitch <= 10)) stallWarning)

stallWarningPitchViolation :: Word64 -> Word64 -> Spec
stallWarningPitchViolation amt dist =
  Copilot.trigger
    "stall_warning_pitch_violation"
    (MTL.since amt (amt + dist - 1) clk dist (pitch < 0 || pitch > 10) stallWarning)
    [(arg ((replicate 10 False) ++ stallWarning)), (arg ((replicate 10 0) ++ clk)), (arg ((replicate 10 0.0) ++ pitch)),
     (arg ((replicate 9 False) ++ stallWarning)), (arg ((replicate 9 0) ++ clk)), (arg ((replicate 9 0.0) ++ pitch)),
     (arg ((replicate 8 False) ++ stallWarning)), (arg ((replicate 8 0) ++ clk)), (arg ((replicate 8 0.0) ++ pitch)),
     (arg ((replicate 7 False) ++ stallWarning)), (arg ((replicate 7 0) ++ clk)), (arg ((replicate 7 0.0) ++ pitch)),
     (arg ((replicate 6 False) ++ stallWarning)), (arg ((replicate 6 0) ++ clk)), (arg ((replicate 6 0.0) ++ pitch)),
     (arg ((replicate 5 False) ++ stallWarning)), (arg ((replicate 5 0) ++ clk)), (arg ((replicate 5 0.0) ++ pitch)),
     (arg ((replicate 4 False) ++ stallWarning)), (arg ((replicate 4 0) ++ clk)), (arg ((replicate 4 0.0) ++ pitch)),
     (arg ((replicate 3 False) ++ stallWarning)), (arg ((replicate 3 0) ++ clk)), (arg ((replicate 3 0.0) ++ pitch)),
     (arg ((replicate 2 False) ++ stallWarning)), (arg ((replicate 2 0) ++ clk)), (arg ((replicate 2 0.0) ++ pitch)),
     (arg ([False] ++ stallWarning)), (arg ([0] ++ clk)), arg ([0.0] ++ pitch),
     arg stallWarning, arg clk, arg pitch]
  
  where

  pitch :: Stream Float
  pitch = extern "pitch_deg" Nothing

  stallWarning :: Stream Bool
  stallWarning = extern "stall_warning" Nothing

main :: IO()
main = reify spec >>= compile defaultParams
