import Data.List (permutations, subsequences)

myInt = 5
double :: Integer -> Integer
double x = 2 * x

permute :: [a] -> [[a]]
permute = permutations

sumsq::Integer->Integer->Integer
sumsq x y = 
     x*x + y*y

paritate::Integer->String
paritate x =
     if even x
          then "par"
          else "impar"

fact::Integer->Integer
fact x =
     if x==0
          then 1
          else x * fact (x-1)

comparer ::Integer->Integer->Bool
comparer x y =
     x > 2 * y