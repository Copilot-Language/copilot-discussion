import System.IO
import Data.Char

-- Generate angle_driver.c:
-- Reads LLA values in from lla.txt

driver steps =
  "#include \"copilot-c99-codegen/copilot.h\"\n" ++
  "#include<stdio.h>\n\n" ++
  (declareExterns 255) ++ (triggers 253) ++
  "int main (void) {\n" ++
  (updateExterns steps) ++
  "}"

  where

  declareExterns 0 = 
    "bool waypoint_in_path_0;\n" ++
    "float waypoint_alt_0;\n" ++
    "float waypoint_long_0;\n" ++
    "float waypoint_lat_0;\n"
  declareExterns n = 
    "bool waypoint_in_path_" ++ (show n) ++ ";\n" ++
    "float waypoint_alt_" ++ (show n) ++ ";\n" ++ 
    "float waypoint_long_" ++ (show n) ++ ";\n" ++
    "float waypoint_lat_" ++ (show n) ++ ";\n"
    ++ (declareExterns $ n - 1)

  updateExterns [] = ""
  updateExterns (s:ss) = 
    "  printf(\"Next Set of Waypoints:\\n\");\n"
    ++ (assignExterns 256 0 s) ++ "  step();\n"
    ++ (updateExterns ss)
  
  assignExterns 0 _ _ = ""
  assignExterns n k [] = 
    "  waypoint_in_path_" ++ (show k) ++ " = false;\n" ++
    "  waypoint_alt_" ++ (show k) ++ " = 0;\n" ++ 
    "  waypoint_long_" ++ (show k) ++ " = 0;\n" ++
    "  waypoint_lat_" ++ (show k) ++ " = 0;\n"
    ++ (assignExterns (n - 1) (k + 1) [])
  assignExterns n k (vec:vecs) = 
    "  waypoint_in_path_" ++ (show k) ++ " = true;\n" ++
    "  waypoint_alt_" ++ (show k) ++ " = " ++ (vec !! 2) ++ ";\n" ++
    "  waypoint_long_" ++ (show k) ++ " = " ++ (vec !! 1) ++ ";\n" ++
    "  waypoint_lat_" ++ (show k) ++ " = " ++ (vec !! 0) ++ ";\n"
    ++ (assignExterns (n - 1) (k + 1) vecs)

  triggers 0 =
    "void angleBetween0 (float f) {\n" ++
    "  printf(\"Angle 0: %f radians\\n\", f);\n" ++
    "}\n"
  triggers n =
    "void angleBetween" ++ (show n) ++ " (float f) {\n" ++
    "  printf(\"Angle " ++ (show n) ++ ": %f radians\\n\", f);\n" ++
    "}\n" ++ (triggers $ n - 1) 

parseLLAs :: String -> [[[String]]]
parseLLAs llas = break (lines llas) []
  where
  break [] acc = [map words (reverse acc)]
  break (l:ls) acc = if (l == "---")
                     then (map words (reverse acc)):(break ls [])
                     else (break ls (l:acc))

main = do
       handle <- openFile "lla.txt" ReadMode
       llas <- hGetContents handle
       writeFile "angle_driver.c" (driver (parseLLAs llas))
