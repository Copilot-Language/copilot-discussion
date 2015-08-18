import Copilot.Library.MTL as MTL
import qualified Prelude as P
import Copilot.Language
import Copilot.Library.Utils
import Copilot.Compile.C99
import Copilot.Language.Reify
import Copilot.Core.PrettyPrint as PP

-- Code to generate some tests for the MTL module
-- Compare results of the MTL functions with expected results based on MTL semantics

-- v0:
-- T   F   F   T   F   F   T   F   F   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T
-- 0   20  27  33  50  66  72  109 130 136 141 149 160 180 187 193 210 226 232 269 290 296 301 309
-- v0':
-- T   F   T   T   F   T   T   F   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T

-- eventually [10,20] v0:
-- F   T   F   F   F   F   F   F   T   T   T   T   T   T   F   T   T   F   F   F   T   T   T   T
-- eventuallyPrev [10,20] v0:
-- F   T   F   F   T   F   F   F   F   F   F   T   T   T   F   T   T   T   F   F   F   F   T   T
-- always [10,20] v0:
-- F   T   T   F   F   T   T   T   T   T ... 
-- alwaysBeen [10,20] v0:
-- T   T   T   F   T   F   T   T   T   T   F   F   T ...
-- until [10,20] v0 v0':
-- F   F   F   F   F   F   F   F   F   T   T   T   T   T   F   T   T   F   F   F   T   T   T   T
-- since [10,20] v0 v0':
-- F   F   F   F   F   F   F   F   F   F   T   T   T   T   F   T   T   T   F   F   F   F   T   T
-- release [10,20] v0 v0':
-- T   T   T   T   T   T   T   T   T ...
-- trigger [10,20] v0 v0':
-- T   T   T   T   T   F   T   T   T ...
-- matchingUntil [10,20] v0 v0':
-- F   F   F   F   F   F   F   F   F   T   T   T   T   T   F   T   T   F   F   F   T   T   T   T
-- matchingSince [10,20] v0 v0':
-- F   F   F   F   F   F   F   F   F   F   F   T   T   T   F   T   T   T   F   F   F   F   T   T
-- matchingRelease [10,20] v0 v0':
-- T...
-- matchingTrigger [10,20] v0 v0':
-- T   T   T   T   T   F  T...
v0 = (P.take 10 (P.cycle [True, False, False])) ++ true
v0' = (P.take 10 (P.cycle [True, False, True])) ++ true
t0 :: Stream Int32
t0 = [0,20,27,33,50,66,72,109,130,136,141,149] ++ (160 + t0)
lb0 = 10
ub0 = 20
eventually0 =
  [False, True] ++ (replicate 6 False) ++ (replicate 4 True) ++
  (cycle [True, True, False, True, True, False, False, False, True, True, True, True])
eventuallyPrev0 =
  [False, True, False, False, True] ++ (replicate 6 False) ++ [True] ++
  (cycle [True, True, False, True, True, True, False, False, False, False, True, True])
always0 =
  [False, True, True, False, False] ++ true
alwaysBeen0 = [True, True, True, False, True, False] ++ (replicate 4 True) ++ [False, False] ++ true 
until0 = (replicate 9 False) ++ (replicate 3 True) ++
   (cycle [True, True, False, True, True, False, False, False, True, True, True, True])
since0 = (replicate 10 False) ++ [True, True] ++
  (cycle [True, True, False, True, True, True, False, False, False, False, True, True])
release0 = true
trigger0 = (replicate 5 True) ++ [False] ++ true
matchingUntil0 = until0
matchingSince0 = (replicate 11 False) ++ [True] ++
  (cycle [True, True, False, True, True, True, False, False, False, False, True, True])
matchingRelease0 = release0
matchingTrigger0 = trigger0


-- v1:
-- T   F   T   T   F   T   T   F   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T
-- 0   20  27  33  50  66  72  109 130 136 141 149 160 180 187 193 210 226 232 269 290 296 301 309
-- v1':
-- T   F   F   T   F   F   T   F   F   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T

-- eventually [10,20] v1:
-- F   T   F   F   T   F   F   F   T   T   T   T   T   T   F   T   T   F   F   F   T   T   T   T
-- eventuallyPrev [10,20] v1:
-- F   T   F   F   T   F   F   F   F   F   T   T   T   T   F   T   T   T   F   F   F   F   T   T
-- always [10,20] v1:
-- F   T   T   F   T   T   T   T   T   T ...
-- alwaysBeen [10,20] v1:
-- T   T   T   F   T   F   T   T   T ...
-- until [10,20] v1 v1':
-- F   F   F   F   F   F   F   F   T   T   T   T   T   T   F   T   T   F   F   F   T   T   T   T
-- since [10,20] v1 v1':
-- F   F   F   F   F   F   F   F   F   F   F   T   T   T   F   T   T   T   F   F   F   F   T   T
-- release [10,20] v1 v1':
-- T   T   T   T   F   T   T   T   T   T   T ... 
-- trigger [10, 20] v1 v1':
-- T   T   T   T   T   T   T   T   T   T   T ...
-- matchingUntil [10,20] v1 v1':
-- F   F   F   F   F   F   F   F   T   T (until) 
-- matchingSince [10,20] v1 v1':
-- F   F   F   F   F   F   F   F   F   F   F   T   T   T   F   T   T   T   F   F   F   F   T   T
-- matchingRelease [10,20] v1 v1':
-- T   T   T   T   T   T   T   T   T ...
-- matchingTrigger [10,20] v1 v1':
-- T   T   T   T   T   T   T   T   T   T   T ...
v1 = v0'
v1' = v0
t1 = t0
lb1 = lb0
ub1 = ub0
eventually1 = [False, True, False, False, True, False, False, False] ++ (replicate 4 True) ++
   (cycle [True, True, False, True, True, False, False, False, True, True, True, True])
eventuallyPrev1 = [False, True, False, False, True] ++ (replicate 5 False) ++ [True, True] ++
   (cycle [True, True, False, True, True, True, False, False, False, False, True, True])
always1 = [False, True, True, False] ++ true
alwaysBeen1 = [True, True, True, False, True, False] ++ true
until1 = (replicate  8 False) ++ (replicate 4 True) ++
   (cycle [True, True, False, True, True, False, False, False, True, True, True, True])
since1 = (replicate 11 False) ++ [True] ++
  (cycle [True, True, False, True, True, True, False, False, False, False, True, True])
release1 = (replicate 4 True) ++ [False] ++ true
trigger1 = true
matchingUntil1 = until1
matchingSince1 = since1
matchingRelease1 = true
matchingTrigger1 = trigger1

-- v2:
-- T  T  T  F  T  T  T  F  T  T  T  T  T  T  T  T  T  T  T
-- 0  5  10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
-- v2':
-- F  T  F  F  F  T  F  F  F  T  T  T  T  T  T  T  T  T  T

-- eventually [5,15] v2: true
-- eventuallyPrev [5, 15] v2:
-- F T ...
-- always [5,15] v2:
-- F  F  F  T  F  F  F  T ...
-- alwaysPrev [5,15] v2:
-- T  T  T  T  F  F  F  T  F  F  F  T ...
-- until [5,15] v2 v2':
-- T  F  F  F  T  F  F  F  T  T ...
-- since [5,15] v2 v2':
-- F  F  T  F  F  F  T  F  F  F  T ...
-- release [5,15] v2 v2':
-- T  T  T  F  T  T  T  F  T ... 
-- trigger [5,15] v2 v2':
-- T  T  T  F  T  T  T  F  T  T ...
-- matchingUntil [5,15] v2 v2':
-- T  F  F  F  T  F  F  F  T  T ...
-- matchingSince [5,15] v2 v2':
-- F  F  T  F  F  F  T  F  F  F  T ...
-- matchingRelease [5,15] v2 v2':
-- T  T  T  T  T  T  T  T  T ...
-- matchingTrigger [5,15] v2 v2':
-- T  T  T  T  T  T  T  T  T  T  ...
v2 = (P.take 10 (P.cycle [True, True, True, False])) ++ true
v2' = (P.take 10 (P.cycle [False, True, False, False])) ++ true
t2 = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50] ++ (55 + t3)
lb2 = 5
ub2 = 15
eventually2 = true
eventuallyPrev2 = [False] ++ true
always2 = [False, False, False, True, False, False, False] ++ true
alwaysBeen2 = (replicate 4 True) ++ [False, False, False, True, False, False, False] ++ true
until2 = [True, False, False, False, True, False, False, False] ++ true
since2 = [False, False] ++ until2
release2 = v2
trigger2 = v2
matchingUntil2 = until2
matchingSince2 = since2
matchingRelease2 = true
matchingTrigger2 = true

-- v3:
-- F  T  F  F  F  T  F  F  F  T  T  T  T  T  T  T  T  T  T
-- 0  5  10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
-- v3':
-- T  T  T  F  T  T  T  F  T  T  T  T  T  T  T  T  T  T  T

-- eventually [5,15] v3:
-- T  F  T  T  T  F  T  T  T ...
-- eventuallyPrev [5,15] v3:
-- F  F  T  T  T  F  T  T  T  F  T ...
-- always [5,15] v3:
-- F  F  F  F  F  F  F  F  T ...
-- alwaysBeen [5,15] v3:
-- T  F  F  F  F  F  F  F  F  F  F  F  T ... 
-- until [5,15] v3 v3':
-- F  T  F  F  F  T  F  F  F  T ...
-- since [5,15] v3 v3':
-- F  T  F  F  F  T  F  F  F  T ...
-- release [5,15] v3 v3':
-- T  T  F  T  T  T  F  T  T ...
-- trigger [5,15] v3 v3':
-- T  T  T  T  F  T  T  T  F  T ...
-- matchingUntil [5,15] v3 v3':
-- F  F  F  F  F  F  F  F  F  T ...
-- matchingSince [5,15] v3 v3':
-- F  F  F  F  F  F  F  F  F  F  T  ...
-- matchingRelease [5,15] v3 v3':
-- T  T  F  T  T  T  F  T  T ...
-- matchingTrigger [5,15] v3 v3':
-- T  T  T  T  F  T  T  T  F  T ...
v3 = (P.take 10 (P.cycle [False, True, False, False])) ++ true
v3' = (P.take 10 (P.cycle [True, True, True, False])) ++ true
t3 :: Stream Int32
t3 = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50] ++ (55 + t3)
lb3 = 5
ub3 = 15
eventually3 = [True, False, True, True, True, False] ++ true
eventuallyPrev3 =[False, False, True, True, True, False, True, True, True, False] ++ true
always3 = (replicate 8 False) ++ true
alwaysBeen3 = [True] ++ (replicate 11 False) ++ true
until3 = v3
since3 = v3
release3 = [True, True, False, True, True, True, False] ++ true
trigger3 = (replicate 4 True) ++ [False, True, True, True, False] ++ true
matchingUntil3 = (replicate 9 False) ++ true
matchingSince3 = (replicate 10 False) ++ true
matchingRelease3 = release3
matchingTrigger3 = trigger3

-- v4:
-- T  F  T  T  T  F  F  F  F  T  F  F  T  T  T  T  T  T  T  T  T  T  T  T  T  T
-- clk:
-- 3  6  8  11 14 16 18 21 23 26 28 30 32 35 38 40 43 46 48 50 53 55 58 60 62 64
-- v4':
-- F  F  T  T  F  F  T  T  T  T  F  F  T  T  T  T  T  T  T  T  T  T  T  T  T  T 
-- eventually [3,7] v4:
-- T  T  T  T  F  F  F  T  T  T  T  T ...
-- eventuallyPrev [3,7] v4:
-- F  T  T  T  T  T  T  T  F  F  F  T  T ...
-- always [3,7] v4:
-- F  T  T  F  F  F  F  F  F  F  T  T ...
-- alwaysBeen [3,7] v4:
-- T  T  T  F  T  T  T  F  F  F  F  F  F  F  T ...
-- until [3,7] v4 v4':
-- F  F  T  F  F  F  F  F  F  F  F  F  T ...
-- since [3,7] v4 v4':
-- F  F  F  T  T  F  F  F  F  T  F  F  F  T ...
-- release [3,7] v4 v4':
-- T  T  T  T  T  T  T  T  T  T  T  T ...
-- trigger [3,7] v4 v4':
-- T  F  T  T  T  T  F  F  F  T  T  T  T ...
-- matchingUntil [3,7] v4 v4':
-- F  F  T  F  F  F  F  F  F  F  F  F  T ...
-- matchingSince [3,7] v4 v4':
-- F  F  F  T  T  F  F  F  F  F  F  F  F  T ...
-- matchingRelease [3,7] v4 v4':
-- T ...
-- matchingTrigger [3,6] v4 v4':
-- T  T  T  T  T  T  T  F  F  T  T  T  T ...   

v4 = [True, False, True, True, True] ++ (replicate 4 False) ++ [True, False, False] ++ true
v4' = [False, False, True, True, False, False] ++ (replicate 4 True) ++ [False, False] ++ true
t4 :: Stream Int32
t4 = [3, 6, 8, 11, 14, 16, 18, 21, 23, 26, 28, 30, 32] ++ (32 + t4)
lb4 = 3
ub4 = 7
eventually4 = (replicate 4 True) ++ [False, False, False] ++ true
eventuallyPrev4 = [False] ++ (replicate 7 True) ++ [False, False, False] ++ true
always4 = [False, True, True] ++ (replicate 7 False) ++ true
alwaysBeen4 = [True, True, True, False, True, True, True] ++ (replicate 7 False) ++ true
until4 = [False, False, True] ++ (replicate 9 False) ++ true
since4 = [False, False, False, True, True] ++ (replicate 4 False) ++ [True, False, False, False] ++ true
release4 = true
trigger4 = [True, False] ++ (replicate 4 True) ++ [False, False, False] ++ true
matchingUntil4 = until4
matchingSince4 = [False, False, False, True, True] ++ (replicate 8 False) ++ true
matchingRelease4 = true
matchingTrigger4 = (replicate 7 True) ++ [False, False] ++ true


-- v5:
-- F  F  T  T  F  F  T  T  T  T  F  F  T  T  T  T  T  T  T  T  T  T  T  T  T  T 
-- clk:
-- 3  6  8  11 14 16 18 21 23 26 28 30 32 35 38 40 43 46 48 50 53 55 58 60 62 64
-- v5':
-- T  F  T  T  T  F  F  F  F  T  F  F  T  T  T  T  T  T  T  T  T  T  T  T  T  T
-- eventually [3,7] v5:
-- T  T  T  T  T  T  T  T  T  T  T  T  ...
-- eventuallyPrev [3,7] v5:
-- F  F  F  T  T  T  T  T  T  T  T  T  T ...
-- always [3,7] v5:
-- F  T  F  F  T  T  T  F  F  F  T  T ...
-- alwaysBeen [3,7] v5:
-- T  F  F  F  T  T  F  F  F  T  T  T  F  F  T ...
-- until [3,7] v5 v5':
-- F  F  T  T  F  F  F  T  T  F  F  F  T ...
-- since [3,7] v5  v5':
-- F  F  F  T  F  F  F  F  F  F  F  F  F  T ...
-- release [3,7] v5 v5':
-- F  T  T  T  F  T  T  T  T  T  T  ...
-- trigger [3,7] v5 v5':
-- T  T  T  T  T  T  T  T  T  T  T  T  T  T  T ...
-- matchingUntil [3,7] v5 v5':
-- F  F  T  F  F  F  F  T  T  F  F  F  T ...
-- matchingSince [3,7] v5 v5':
-- F  F  F  T  F  F  F  F  F  F  F  F  F  T ...
-- matchingRelease [3,7] v5 v5':
-- F  T  T  T  T  T  T  T ...
-- matchingTrigger [3,7] v5 v5':
-- T  T  T  T  T  T  T  T  T  T  T  T  T ...

v5 = v4'
v5' = v4
t5 = t4
lb5 = 3
ub5 = 7
eventually5 = true
eventuallyPrev5 = [False, False, False] ++ true
always5 = [False, True, False, False, True, True, True, False, False, False] ++ true
alwaysBeen5 = [True, False, False, False, True, True, False, False, False, True, True, True, False, False] ++ true
until5 = [False, False, True, True, False, False, False, True, True, False, False, False] ++ true
since5 = [False, False, False, True] ++ (replicate 9 False) ++ true
release5 = [False, True, True, True, False] ++ true
trigger5 = true
matchingUntil5 = [False, False, True] ++ (replicate 4 False) ++ [True, True, False, False, False] ++ true
matchingSince5 = [False, False, False, True] ++ (replicate 9 False) ++ true
matchingRelease5 = [False] ++ true
matchingTrigger5 = true

-- v6:
-- F   F   F   F   T   T   T   T   F   F   F
-- t6:
-- 400 455 505 547 601 649 698 747 804 856 900
-- v6':
-- F   T   F   F   F   F   F   F   F   F   F
-- eventually [0,200] v6:
-- F   T   T   T   T   T   T   T   F   F   F ...
-- eventuallyPrev [0,200] v6:
-- F   F   F   F   T   T   T   T   T   T   T   F ...   
-- always [0,200] v6:
-- F   F   F   F   T   F   F   F   F ...
-- alwaysBeen [0,200] v6:
-- F   F   F   F   F   F   F   F ...
-- until [0,200] v6 v6':
-- F   T   F...
-- since [0,200] v6 v6':
-- F ...
-- release [0,200] v6 v6':
-- F   F   F   F ...
-- trigger [0,200] v6 v6':
-- F   F   F   F ...
-- matchingUntil [0,200] v6 v6':
-- F   T   F ...
-- matchingSince [0,200] v6 v6':
-- F ...
-- matchingRelease [0,200] v6 v6':
-- F   F   F   F   T   T   T   T   F ...
-- matchingTrigger [0,200] v6 v6':
-- F   F   F   F   T   T   T   T   F ...
v6 = [False, False, False, False, True, True, True, True, False, False, False] ++ false
v6' = ([False, True] P.++ (replicate 10 False)) ++ false
t6 :: Stream Int32
t6 = [400, 455, 505, 547, 601, 649, 698, 747, 804, 856, 900] ++ (550 + t6)
lb6 = 0
ub6 = 200
eventually6 = [False] ++ (replicate 7 True) ++ false
eventuallyPrev6 = (replicate 4 False) ++ (replicate 7 True) ++ false
always6 = (replicate 4 False) ++ [True] ++ false
alwaysBeen6 = false
until6 = [False, True] ++ false
since6 = [False, True] ++ false
release6 = false
trigger6 = false
matchingUntil6 = false
matchingSince6 = false
matchingRelease6 = v6
matchingTrigger6 = v6

-- v7:
-- F  T  T  T  F  F  F  T  F  F  T  T  T  F  F ...
-- t7:
-- 19 20 22 23 24 25 27 28 31 32 33 34 36 37 38
-- v7':
-- T  F  F  F  T  T  T  F  T  T  F  F  F  T  T ...
-- eventually [3,5] v7:
-- T  T  F  T  T  T  F  T  T  T  T  F  F  ...
-- eventuallyPrev [3,5] v7:
-- F  F  F  T  T  T  T  T  T  T  T  F  T  T  T  T  T  F ...
-- always[3,5] v7:
-- F  F  F  F  F  T  F  F  T  F  F  F ...
-- alwaysBeen [3,5] v7:
-- T  T  F  F  F  T  F  F  F  F  T  F  F  F  T  T  F ...
-- until [3,5] v7 v7':
-- F  T  F  F  F  F  F  T  F  F  T  T  F ...
-- since [3,5] v7 v7':
-- F  F  T  T  F  F  F  F  F  F  F  F  T  F ...
-- release [3,5] v7 v7':
-- T  T  T  T  F  F  T  T  T  T  T  T  T  T ...
-- trigger [3,5] v7 v7':
-- T  T  T  T  T  T  F  T  F  F  T  T  T  T  T  F  F  T ...
-- matchingUntil [3,5] v7 v7':
-- F ...
-- matchingSince [3,5] v7 v7':
-- F ...
-- matchingRelease [3,5] v7 v7':
-- T ...
-- matchingSince [3,5] v7 v7':
-- T ...
v7 = [False, True, True, True, False, False, False, True, False, False, True, True, True] ++ false
v7' = [True, False, False, False, True, True, True, False, True, True, False, False, False] ++ true
t7 :: Stream Int32
t7 = [19, 20, 22, 23, 24, 25, 27, 28, 31, 32, 33 ,34 ,36, 37, 38] ++ (20 + t7)
lb7 = 3
ub7 = 5
eventually7 = [True, True, False, True, True, True, False] ++ (replicate 4 True) ++ false
eventuallyPrev7 = [False, False, False] ++ (replicate 8 True) ++ [False] ++ (replicate 5 True) ++ false
always7 = (replicate 5 False) ++ [True, False, False, True] ++ false
alwaysBeen7 = [True, True, False, False, False, True] ++ (replicate 4 False) ++ [True, False, False, False, True, True] ++ false
until7 = [False, True] ++ (replicate 5 False) ++ [True, False, False, True, True] ++ false
since7 = [False, False, True, True] ++ (replicate 8 False) ++ [True] ++ false
release7 = [True, True, True, True, False, False] ++ true
trigger7 = (replicate 6 True) ++ [False, True, False, False] ++ (replicate 5 True) ++ [False, False] ++ true
matchingUntil7 = false
matchingSince7 = false
matchingRelease7 = true
matchingTrigger7 = true

-- v8:
-- T  F  F  F  T  T  T  F  T  T  F  F  F  T  T ...
-- t7:
-- 19 20 22 23 24 25 27 28 31 32 33 34 36 37 38
-- v8':
-- F  T  T  T  F  F  F  T  F  F  T  T  T  F  F ...
-- eventually [3,5] v8:
-- T  T  T  T  T  F  T  T  F  T  ...
-- eventuallyPrev [3,5] v8:
-- F  F  T  T  T  F  T  T  T  T  F  T  T  T  F  F  T  ...
-- always [3,5] v8 v8':
-- F  F  T  F  F  F  T  F  F  F  F  T  ...
-- alwaysBeen [3,5] v8:
-- T  T  T  F  F  F  F  F  F  F  F  T  F  F  F  F  F  T  ...
-- until [3,5] v8 v8': 
-- F  F  F  F  T  T  F  F  F  F  F  F  F  ...
-- since [3,5] v8 v8':
-- F  F  F  F  F  F  T  F  T  T  F  F  F  F  F  T  T  F  ...
-- release [3,5] v8 v8':
-- T  F  T  T  T  T  T  F  T  T  F  F  T  ...
-- trigger [3,5] v8 v8':
-- T  T  F  F  T  T  T  T  T  T  T  T  F  T  ...
-- matchingUntil [3,5] v8 v8':
-- F ...
-- matchingSince [3,5] v8 v8':
-- F ...
-- matchingRelease [3,5] v8 v8':
-- T ...
-- matchingTrigger [3,5] v8 v8':
-- T ...
v8 = v7'
v8' = v7
t8 = t7
lb8 = lb7
ub8 = ub7
eventually8 = (replicate 5 True) ++ [False, True, True, False] ++ true
eventuallyPrev8 = [False, False, True, True, True, False, True, True, True, True, False, True, True, True, False, False] ++ true
always8 = [False, False, True, False, False, False, True] ++ (replicate 4 False) ++ true
alwaysBeen8 = [True, True, True] ++ (replicate 8 False) ++ [True] ++ (replicate 5 False) ++ true
until8 = (replicate 4 False) ++ [True, True] ++ false
since8 = (replicate 6 False) ++ [True, False, True, True] ++ (replicate 5 False) ++ [True, True] ++ false
release8 = [True, False] ++ (replicate 5 True) ++ [False, True, True, False, False] ++ true
trigger8 = [True, True, False, False] ++ (replicate 8 True) ++ [False] ++ true
matchingUntil8 = false
matchingSince8 = false
matchingRelease8 = true
matchingTrigger8 = true

-- v9:
-- T  F  F  T  F  F  T  F  T  T  F  F  F  (cycle)
-- t9:
-- 48 51 54 58 67 70 73 77 80 83 88 92 95 98
-- v9':
-- T  T  F  T  T  F  T  T  F  T  T  F  F  (cycle)
-- eventually [3,3] v9:
-- F  F  F  F  F  T  F  T  T  F  F  F  T
-- eventuallyPrev [3,3] v9:
-- F  T  F  F  F  F  F  F  F  T  F  F  F
-- always [3,3] v9:
-- F  F  T  T  F  T  T  T  T  T  T  F  T
-- alwaysBeen [3,3] v9:
-- T  T  F  T  T  F  F  T  F  T  T  T  F  F  T  F  T  T  F  F  T  F  T  T  T  F
-- until [3,3] v9 v9':
-- T  F  F  F  F  F  F  F  T  F  F  F  F
-- since [3,3] v9 v9':
-- F  F  F  F  F  F  F  F  T  F  F  F  F 
-- release [3,3] v9 v9':
-- T  F  T  T  F  T  T  F  T  T  T  F  T
-- trigger [3,3] v9 v9':
-- T  T  T  T  T  T  T  T  T  T  T  T  F 
-- matchingUntil [3,3] v9 v9':
-- F  F  F  F  F  F  F  F  T  F  F  F  F
-- matchingSince [3,3] v9 v9':
-- F  F  F  F  F  F  F  F  F ...
-- matchingRelease [3,3] v9 v9':
-- T  F  T  T  F  T  T  T  T  T  T  F  T  
-- matchingTrigger [3,3] v9 v9':
-- T  T  T  T  T  T  T  T  T  T  T  T  F 
v9 = cycle [True, False, False, True, False, False, True, False, True, True, False, False, False]
v9' = cycle [True, True, False, True, True, False, True, True, False, True, True, False, False]
t9 :: Stream Int32
t9 = [48, 51, 54, 58, 67, 70, 73, 77, 80, 83, 88, 92, 95] ++ (50 + t9)
lb9 = 3
ub9 = 3
eventually9 = cycle $ (replicate 5 False) P.++ [True, False, True, True, False, False, False, True]
eventuallyPrev9 = cycle $ [False, True] P.++ (replicate 7 False) P.++ [True, False, False, False]
always9 = cycle $ [False, False, True, True, False] P.++ (replicate 6 True) P.++ [False, True]
alwaysBeen9 = [True, True, False, True, True, False, False, True, False, True, True, True, False] ++
              (cycle [False, True, False, True, True, False, False, True, False, True, True, True, False])
until9 = cycle $ [True] P.++ (replicate 7 False) P.++ [True] P.++ (replicate 4 False)
since9 = cycle $ (replicate 8 False) P.++ [True] P.++ (replicate 4 False)
release9 = cycle [True, False, True, True, False, True, True, False, True, True, True, False, True]
trigger9 = cycle $ (replicate 12 True) P.++ [False]
matchingUntil9 = cycle $ (replicate 8 False) P.++ [True] P.++ (replicate 4 False)
matchingSince9 = false
matchingRelease9 = cycle $ [True, False, True, True, False] P.++ (replicate 6 True) P.++ [False, True]
matchingTrigger9 = trigger9


-- Put it all together
vals = [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9]
vals' = [v0', v1', v2', v3', v4', v5', v6', v7', v8', v9']
lbs = [lb0, lb1, lb2, lb3, lb4, lb5, lb6, lb7, lb8, lb9]
ubs = [ub0, ub1, ub2, ub3, ub4, ub5, ub6, ub7, ub8, ub9]
ts = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]
ds = [5, 5, 5, 5, 2, 2, 40, 1, 1, 3]
eventually_exp = [eventually0, eventually1, eventually2, eventually3, eventually4,
                  eventually5, eventually6, eventually7, eventually8, eventually9]
eventuallyPrev_exp = [eventuallyPrev0, eventuallyPrev1, eventuallyPrev2, eventuallyPrev3,
                      eventuallyPrev4, eventuallyPrev5, eventuallyPrev6, eventuallyPrev7,
                      eventuallyPrev8, eventuallyPrev9]
always_exp = [always0, always1, always2, always3, always4, always5, always6, always7, always8, always9]
alwaysBeen_exp = [alwaysBeen0, alwaysBeen1, alwaysBeen2, alwaysBeen3, alwaysBeen4,
                  alwaysBeen5, alwaysBeen6, alwaysBeen7, alwaysBeen8, alwaysBeen9]
until_exp = [until0, until1, until2, until3, until4, until5, until6, until7, until8, until9]
since_exp = [since0, since1, since2, since3, since4, since5, since6, since7, since8, since9]
release_exp = [release0, release1, release2, release3, release4, release5, release6, release7, release8, release9]
trigger_exp = [trigger0, trigger1, trigger2, trigger3, trigger4, trigger5, trigger6, trigger7, trigger8, trigger9]
matchingUntil_exp = [matchingUntil0, matchingUntil1, matchingUntil2, matchingUntil3,
                     matchingUntil4, matchingUntil5, matchingUntil6, matchingUntil7,
                     matchingUntil8, matchingUntil9]
matchingSince_exp = [matchingSince0, matchingSince1, matchingSince2, matchingSince3,
                     matchingSince4, matchingSince5, matchingSince6, matchingSince7,
                     matchingSince8, matchingSince9]
matchingRelease_exp = [matchingRelease0, matchingRelease1, matchingRelease2, matchingRelease3,
                       matchingRelease4, matchingRelease5, matchingRelease6, matchingRelease7,
                       matchingRelease8, matchingRelease9]
matchingTrigger_exp = [matchingTrigger0, matchingTrigger1, matchingTrigger2, matchingTrigger3,
                       matchingTrigger4, matchingTrigger5, matchingTrigger6, matchingTrigger7,
                       matchingTrigger8, matchingTrigger9]


-- These compare result stream with expected result stream
-- using (==), so "false" in the "match" stream indicates
-- a mismatch between the expected value and the actual value

tester1 name l u clk v op dist expected n = do
  let res = op l u clk dist v
  observer (name P.++ n') res
  observer (name P.++ "_match" P.++ n') (expected == res)
  observer (name P.++ "_expected" P.++ n') expected
  where
    n' = show n

tester2 name l u clk v1 v2 op dist expected n = do
  let res = op l u clk dist v1 v2
  observer (name P.++ n') res
  observer (name P.++ "_match" P.++ n') (expected == res)
  observer (name P.++ "_expected" P.++ n') expected
  where
    n' = show n


-- Functions for compiling

test1 name op [lb] [ub] [t] [v] [d] [e] n = tester1 name lb ub t v op d e n
test1 name op (lb:lbs) (ub:ubs) (t:ts) (v:vs) (d:ds) (e:es) n = do
  (tester1 name lb ub t v op d e n)
  test1 name op lbs ubs ts vs ds es (n + 1)
   
test2 name op [lb] [ub] [t] [v] [v'] [d] [e] n = tester2 name lb ub t v v' op d e n
test2 name op (lb:lbs) (ub:ubs) (t:ts) (v:vs) (v':vs') (d:ds) (e:es) n = do
  (tester2 name lb ub t v v' op d e n)
  test2 name op lbs ubs ts vs vs' ds es (n + 1)

test [] [] [] [] lbs ubs ts vs vs' ds _ _ = do
  tester_clk ts 0
  tester_v vs "1" 0
  tester_v vs "2" 0
  where
  tester_clk [t] n = observer ("clk" P.++ (show n)) t
  tester_clk (t:ts) n = do
    observer ("clk" P.++ (show n)) t
    tester_clk ts (n + 1)
  tester_v [v] k n = observer ("vals" P.++ k P.++ (show n)) v
  tester_v (v:vals) k n = do
    observer ("vals" P.++ k P.++ (show n)) v
    tester_v vals k (n + 1)
test [] _ (n2:names2) (o2:ops2) lbs ubs ts vs vs' ds _ (es2:ess2) = do
  (test2 n2 o2 lbs ubs ts vs vs' ds es2 0)
  test [] [] names2 ops2 lbs ubs ts vs vs' ds [] ess2
test (n1:names1) (o1:ops1) names2 ops2 lbs ubs ts vs vs' ds (es1:ess1) ess2 = do
  (test1 n1 o1 lbs ubs ts vs ds es1 0)
  test names1 ops1 names2 ops2 lbs ubs ts vs vs' ds ess1 ess2

-- Generate the contents of the C file that will check for mismatches between the expected and actual values
cstring iters names num =
  "#include \"test_copilot-c99-codegen/test_copilot.h\"\n" P.++
  "#include <stdio.h>\n" P.++
  "int iters = " P.++ (show iters) P.++ ";\n\n" P.++
  "void err (char* functionName, int32_t clk, bool expected) {\n" P.++
  "  printf(\"Problem at time %d with function %s: expected %d\\n\", clk, functionName, expected);\n" P.++
  "}\n\n" P.++
  "int main (void) {\n  int i;\n" P.++
  "  for (i = 0; i < iters; i++) {\n" P.++ 
  "    test_step();\n" P.++
  (check names num) P.++
  "  }\n  printf(\"Test completed.\\n\");\n  return 0;\n}"
  where
    check [] _ = ""
    check (n:ns) 0 = check ns num
    check (n:ns) c =
      "    if (! test_" P.++ n P.++ "_match" P.++ (show (c - 1)) P.++ ") {\n" P.++
      "      err(\"" P.++ n P.++ (show (c - 1)) P.++ "\", test_clk" P.++ (show (c - 1)) P.++
        ", test_" P.++ n P.++ "_expected" P.++ (show (c - 1)) P.++ ");\n" P.++
      "    }\n" P.++ (check (n:ns) (c - 1))

main = do 
  writeFile "tester.c" (cstring 30 ["eventually", "eventuallyPrev", "always", "alwaysBeen",
    "until", "since", "release", "trigger", "matchingUntil", "matchingSince", "matchingRelease", "matchingTrigger"] 10)
  reify (test
    ["eventually", "eventuallyPrev", "always", "alwaysBeen"]
    [eventually, eventuallyPrev, always, alwaysBeen]
    ["until", "since", "release", "trigger", "matchingUntil", "matchingSince", "matchingRelease", "matchingTrigger"]
    [until, since, release, MTL.trigger, matchingUntil, matchingSince, matchingRelease, matchingTrigger]
    lbs ubs ts vals vals' ds
    [eventually_exp, eventuallyPrev_exp, always_exp, alwaysBeen_exp]
    [until_exp, since_exp, release_exp, trigger_exp,
     matchingUntil_exp, matchingSince_exp, matchingRelease_exp, matchingTrigger_exp]) >>= compile (Params {prefix = Just "test", verbose = False})
