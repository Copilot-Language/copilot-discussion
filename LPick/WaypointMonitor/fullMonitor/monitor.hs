import Copilot.Language as C hiding ((!!))
import Copilot.Compile.C99
import Copilot.Language.Reify
import Prelude as P ((!!), replicate, (++))
import Copilot.Library.Utils (cycle)

-- Monitor for three different properties:
-- Requires calling "step()" for each waypoint

numWaypoints :: Int
numWaypoints = 256

numWaypoints' :: Int64
numWaypoints' = 256

-- Must provide 16 polyons and 16 points:
-- Points can be repeated to fill up leftover slots
-- when under 16 points are needed

numPolygonPoints :: Int
numPolygonPoints = 16

numPolygons :: Int
numPolygons = 16

numPolygons' :: Int64
numPolygons' = 16


-- Assumes waypoints are provided in order:
-- Valid and in path: in order of path through waypoints
-- Valid but out of path
-- Invalid

-- Note: "Cutting into the Earth" is not prevented; distances/angles
-- are measured as if there are no obstacles in the way (i.e. traveling
-- in a straight line from point to point)

-- Functions to Generate Extern Names
-- Using externArray is too slow for waypoints
waypointLats :: Stream Float
waypointLats = (extern "waypoint_lats" Nothing)

waypointLongs :: Stream Float
waypointLongs = (extern "waypoint_longs" Nothing)

waypointAlts :: Stream Float
waypointAlts = (extern "waypoint_alts" Nothing)

waypointValid :: Stream Bool
waypointValid = (extern "waypoint_valid" Nothing)

waypointInPath :: Stream Bool
waypointInPath = (extern "waypoint_in_path" Nothing)

waypointReward :: Stream Float
waypointReward = (extern "waypoint_reward" Nothing)

polygonPos :: [[[Stream Float]]]
polygonPos = polygonArr numPolygons numPolygonPoints
  where
  polygonArr 0 _ = []
  polygonArr n k = (polygon n k) : (polygonArr (n - 1) k)
  polygon :: Int -> Int -> [[Stream Float]]
  polygon n 0 = []
  polygon n k =
    [(externArray ("polygon_" P.++ (show (n - 1)) P.++ "_" P.++
     (show (numPolygonPoints - k))) (0 :: Stream Word32) 3 Nothing),
     (externArray ("polygon_" P.++ (show (n - 1)) P.++ "_" P.++
     (show (numPolygonPoints - k))) (1 :: Stream Word32) 3 Nothing),
     (externArray ("polygon_" P.++ (show (n - 1)) P.++ "_" P.++
     (show (numPolygonPoints - k))) (2 :: Stream Word32) 3 Nothing)] :
    (polygon n (k - 1))

-- Functions for converting latitude, longitude, altitude into cartesian
-- coordinates

-- Degrees to radians
degreesToRadians :: Stream Float -> Stream Float
degreesToRadians p = (p * pi / 180)
  where
  pi = acos (-1)

-- Latitude, Longitude, Altitude to cartesian, treating Earth as a sphere
-- with radius 6371km
llaToCartesian :: [Stream Float] -> [Stream Float]
llaToCartesian wps =
  map (* alts) ([cos lats * cos longs, cos lats * sin longs, sin lats])
  where
  lats = wps !! 0
  longs = wps !! 1
  alts  = (wps !! 2) + 6371


-- Functions for manipulating waypoints and vectors

dotProd :: [Stream Float] -> [Stream Float] -> Stream Float
dotProd p1 p2 = foldl1 (+) (zipWith (*) p1 p2)

magnitude :: [Stream Float] -> Stream Float
magnitude p = sqrt (foldl1 (+) (map (** 2) p))

-- List of waypoint positions
waypointPos :: [Stream Float]
waypointPos = [waypointLats, waypointLongs, waypointAlts]

-- Convert latitudes and longitudes to radians
waypointPosLLA :: [Stream Float]
waypointPosLLA = [degreesToRadians (waypointPos !! 0),
                  degreesToRadians (waypointPos !! 1),
                  waypointPos !! 2]

-- Convert latitudes and longitudes to cartesian coordinates
waypointPosCartesian :: [Stream Float]
waypointPosCartesian = llaToCartesian waypointPosLLA


-- Vector list: Center the vectors in pairs at the origin
vectors :: [Stream Float]
vectors =
  zipWith (-) waypointPosCartesian (map ([0] C.++) waypointPosCartesian)

validVectors :: Stream Bool
validVectors = ([False] C.++ waypointInPath) && waypointInPath

-- Angle stream
angles :: Stream Float
angles = mux (magnitudeProduct /= 0) (acos cosOfAngle) 0
  where
  v1 = map ([0] C.++) vectors
  v2 = vectors
  magnitudeProduct = (magnitude v1) * (magnitude v2)
  cosOfAngle = (dotProd v1 v2) / magnitudeProduct
                      
validAngles :: Stream Bool
validAngles = ([False] C.++ validVectors) && validVectors

-- Angle trigger
angleBetween :: Spec
angleBetween = ab (numWaypoints' - 2)
  where
  ab n = trigger "angleBetween"
         (validAngles && (angles >= (pi / 2)))
         [arg angles, arg (counter - 1)] 
  counter :: Stream Int64
  counter = (mux validAngles 1 0) +
    (mux (cycle ([True] P.++ (replicate (numWaypoints - 1) False)))
         0 ([0] C.++ counter))
  pi = acos (-1)


-- Sum of reward(w) / distToSeg(w,s) for all waypoints w not in the path
-- and all segments s in the path

-- Repeat the kth to the (k + n)th values in this set of numWaypoints values
-- until the next set of numWaypoints values in the stream
rep :: Typed a => Int -> Int -> a -> Stream a -> Stream a
rep 0 n d s = s'
  where
  s' =
    mux
      (cycle ((replicate n True) P.++ (replicate (numWaypoints - n) False)))
      s ((replicate n d) C.++ s')
rep k n d s = s'
  where
    s' = mux
           (cycle ((replicate k False) P.++ (replicate n True)
             P.++ (replicate (numWaypoints - n - k) False)))
           s ((replicate n d) C.++ s')

-- Past version of nfoldl1 from Copilot.Library.Utils
pnfoldl1 :: (Typed a)
            => Int -> (Stream a -> Stream a -> Stream a)
                   ->  Stream a -> a -> Stream a
pnfoldl1 1 _ s _ = s 
pnfoldl1 n f s d = f s $ pnfoldl1 (n - 1) f ([d] C.++ s) d

-- Distance of the current waypoint from the segment for which the kth
-- waypoint is the second endpoint
-- wps: array of waypoint streams, ips: inPath stream, vs: valid stream
-- rwds: reward stream, k: which segment
sum wps ips vs rwds k = 
  mux ((magnitude seg) == 0 || dists == 0 || (not vs) || (not segips) || ips) 0 (rwds / dists)
  where
    -- position vectors of waypoints where the kth one is the origin
    -- from the kth waypoint onward
    waypoints = zipWith (-) wps (map (rep (k - 1) 1 0) wps)
    seg = map (rep k 1 0) waypoints
    -- is segment in path?
    segips = rep k 1 False ips
    -- distances of the segment to each of the waypoints
    dists = local (magnitude seg) $ \magn ->
              local ((seg !! 0) / magn) $ \s1 ->
                local ((seg !! 1) / magn) $ \s2 ->
                  local ((seg !! 2) / magn) $ \s3 ->
                    local (waypoints `dotProd` ([s1, s2, s3])) $ \dot ->
                      mux (0 > dot) (magnitude waypoints)
                      (magnitude (zipWith (-)
                        ([mux (dot > 1) (seg !! 0) (s1 * dot),
                          mux (dot > 1) (seg !! 1) (s2 * dot),
                          mux (dot > 1) (seg !! 2) (s3 * dot)]) waypoints))

-- Boundary indicator of the set of waypoints: if two waypoints' indices
-- are the same, then they both "occur at the same time"
index :: Stream Int64
index = (replicate numWaypoints 0) C.++ (1 + index)

-- Triggers sumAverageValue and noFlyZone should only go off every
-- numWaypoints steps
timeToTrigger :: Stream Bool
timeToTrigger = ttt
  where ttt = (replicate (numWaypoints - 1) False) C.++ [True] C.++ ttt

-- Counts number of segments (inPath waypoint count - 1)
numSegments :: Stream Float
numSegments = c + (trueAsOne) - 1
  where
  c = mux
        ([False] C.++ timeToTrigger)
        0 ([0] C.++ (mux waypointInPath (1 + c) c))
  trueAsOne = mux waypointInPath 1 0

-- Sum of the average reward(w) / distToSeg(w,s) for each waypoint.
sumAverageValue :: Spec
sumAverageValue =
  trigger "sum" timeToTrigger
    [arg (pnfoldl1 numWaypoints (+) (sav numWaypoints numSegments) 0)]
  where
   sv :: Int -> Stream Float
   sv 0 = 0
   sv k =  (sv (k - 1)) +
           (mux (index == ((replicate k 0) C.++ index))
                (sum waypointPosCartesian
                     waypointInPath
                     waypointValid
                     waypointReward
                     k) 0)
   sav k count = mux (count == 0) 0 ((sv k) / count)


-- Check if path enters a no-fly zone by checking if any segment in the path
-- intersects with a segment of the polygon defining the no-fly-zone

intersectedSegments wps (p:ps) ips = mask && (intersect polygonPairs)
  where
    -- First point of waypoint line segment
    wp1 :: [Stream Float]
    wp1 = map ([0] C.++) wps
    -- Second point of waypoint line segment
    wp2 :: [Stream Float]
    wp2 = wps
    -- Only use values for line segments that are in the path
    mask = ips && ([False] C.++ ips) &&
           (cycle ([False] P.++ (replicate (numWaypoints - 1) True)))
    -- Pairs of line segment endpoints of the polygon
    polygonPairs = zip (p:ps) (ps P.++ [p])

    wp1x = wp1 !! 0
    wp2x = wp2 !! 0
    wp1y = wp1 !! 1
    wp2y = wp2 !! 1
    wpSlope = (wp2y - wp1y) / (wp2x - wp1x)
    wpYIntercept = wp1y - wpSlope * wp1x
    wpy x = wpSlope * x + wpYIntercept

    -- Does the waypoint line segment intersect with any of the
    -- polygon edges?
    intersect [] = false
    intersect ((sp1, sp2) : pairs) =
      let sp1x = sp1 !! 0
          sp2x = sp2 !! 0
          sp1y = sp1 !! 1
          sp2y = sp2 !! 1
          spSlope = (sp2y - sp1y) / (sp2x - sp1x) 
          spy x = spSlope * x + (sp1y - spSlope * sp1x)
      in
          (wp1x == wp2x && sp1x /= sp2x &&
            (((spy wp1x) > wp1y && wp2y > (spy wp2x)) ||
            (wp1y > (spy wp1x) && (spy wp2x) > wp2y))) ||
          (wp1x /= wp2x && ((sp1y > (wpy sp1x)) && ((wpy sp2x) > sp2y)) ||
            ((wpy sp1x) > sp1y) && (sp2y > (wpy sp2x))) ||
          (intersect pairs)

noFlyZone :: Spec
noFlyZone = nfz (numPolygons - 1) polygonPos
  where
    nfz 0 (p:ps) = trigger "nfz_0"
                     (timeToTrigger &&
                     (pnfoldl1 numWaypoints (||) (intersected p) False)) []
    nfz n (p:ps) = do
                   trigger ("nfz_" P.++ (show n))
                     (timeToTrigger &&
                     (pnfoldl1 numWaypoints (||) (intersected p) False)) []
                   (nfz (n - 1) ps)
    intersected p =
      intersectedSegments waypointPosCartesian p waypointInPath

main = reify (do
                angleBetween
                noFlyZone
                sumAverageValue)
       >>= compile (Params { prefix = Nothing, verbose = False })
