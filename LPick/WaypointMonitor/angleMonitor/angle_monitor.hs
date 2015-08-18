import Copilot.Language hiding ((!!), (++))
import Copilot.Compile.C99
import Copilot.Language.Reify
import Prelude as P ((!!), (++), (<))

-- The "nice version" of the waypoint monitors for angles:
-- Only one call to "step()" per set of waypoints

numWaypoints :: Int
numWaypoints = 256

-- Note: "Cutting into the Earth" is not prevented; distances/angles are
-- measured as if there are no obstacles in the way (i.e. traveling in a
-- straight line from point to point)

-- Functions to Generate Extern Names
waypointPosExterns :: Int -> Int -> [[Stream Float]]
waypointPosExterns n c = if ((P.<) n c) then [] else
                         ( [ extern ("waypoint_lat_" ++ (show c)) Nothing,
                             extern ("waypoint_long_" ++ (show c)) Nothing,
                             extern ("waypoint_alt_" ++ (show c)) Nothing ] )
                         : (waypointPosExterns n (c + 1))

waypointInPathExterns :: Int -> Int -> [Stream Bool]
waypointInPathExterns n c = if ((P.<) n c) then [] else
                           (extern ("waypoint_in_path_" ++ (show c)) Nothing)
                           : (waypointInPathExterns n (c + 1))

-- Functions for converting latitude, longitude, altitude into cartesian
-- coordinates

-- Degrees to radians
degreesToRadians :: [Stream Float] -> [Stream Float]
degreesToRadians p = [(p !! 0) * (pi / 180), (p !! 1) * (pi / 180), (p !! 2)]
  where
  pi = acos (-1)

-- Latitude, Longitude, Altitude to cartesian, treating Earth as a sphere
-- with radius 6371
llaToCartesian :: [Stream Float] -> [Stream Float]
llaToCartesian p = [ r * (cos long) * (cos lat),
                     r * (sin long) * (cos lat),
                     r * (sin lat) ]
  where
    long = p !! 1
    lat = p !! 0
    alt = p !! 2
    r = alt + 6371

-- Functions for manipulating waypoints and vectors

-- Make Pairs: E.g., for a list [a,b,c,d,e], will generate
-- [(a,b), (b,c), (c,d), (d,e)]
makePairs (p:p':ps) = (p,p') : (makePairs (p':ps))
makePairs _ = []


-- Vectors

vectorOp :: (Stream Float -> Stream Float -> Stream Float) ->
  [Stream Float] -> [Stream Float] -> [Stream Float]
vectorOp f v1 v2 = [ f (v1 !! 0) (v2 !! 0),
                     f (v1 !! 1) (v2 !! 1),
                     f (v1 !! 2) (v2 !! 2) ]

-- Get vectors centered at origin
vectorDir :: [Stream Float] -> [Stream Float] -> [Stream Float]
vectorDir start end = vectorOp (-) end start

-- Take a dot product of two vectors
dotProd :: [Stream Float] -> [Stream Float] -> Stream Float
dotProd v1 v2 = foldl1 (+) (vectorOp (*) v1 v2)

-- Magnitude of a vector
magnitude :: [Stream Float] -> Stream Float
magnitude v1 = sqrt ((foldl1 (+)) (map (**2) v1))

-- Manipulate the waypoints:

-- List of waypoint positions
-- - Convert latitudes and longitudes to radians
waypointPosLLA :: [[Stream Float]]
waypointPosLLA = map degreesToRadians (waypointPosExterns (numWaypoints - 1) 0)

waypointPosCartesian :: [[Stream Float]]
waypointPosCartesian = map llaToCartesian waypointPosLLA

-- List of boolean streams that are true when the corresponding waypoint is in
-- the path
waypointInPath :: [Stream Bool]
waypointInPath = waypointInPathExterns (numWaypoints - 1) 0

-- Pairs of position vectors of points, where each pair (p1, p2) represents
-- the vector from point p1 to point p2

pairs :: [([Stream Float], [Stream Float])]
pairs = makePairs waypointPosCartesian

validPairs :: [Stream Bool]
validPairs = map (\x -> (fst x) && (snd x)) (makePairs waypointInPath)

-- Vector list: Center the vectors in pairs at the origin
vectors :: [[Stream Float]]
vectors = map (\x -> vectorDir (fst x) (snd x)) pairs

-- Angle list
angles :: [Stream Float]
angles = map (\x -> (acos ((dotProd (fst x) (snd x)) /
                          ((magnitude (fst x)) * (magnitude (snd x))))))
             (makePairs vectors)
                      
validAngles :: [Stream Bool]    
validAngles = map (\x -> (fst x) && (snd x)) (makePairs (validPairs))

-- Trigger for angles
angleBetween :: Spec
angleBetween = ab (numWaypoints - 3)
  where
    ab n = if ((P.<) 0 n) then do
             trigger ("angleBetween" ++ (show n))
                     ((validAngles !! n) && (angles !! n) >= (pi / 2))
                     [arg (angles !! n)]
             (ab (n - 1))
           else do
             trigger "angleBetween0"
                     ((validAngles !! 0) && (angles !! 0) >= (pi / 2))
                     [arg (angles !! 0)]
    pi = (acos(-1))

main = reify angleBetween >>=
       compile (Params { prefix = Nothing, verbose = False })
