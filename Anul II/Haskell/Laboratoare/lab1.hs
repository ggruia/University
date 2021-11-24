-- 6.
sumSquares :: Int -> Int -> Int
sumSquares x y = x^2 + y^2

parity :: Int -> String
parity x
    | even x = "par"
    | otherwise = "impar"

factorial :: Int -> Int
factorial 1 = 1
factorial x = x * factorial (x - 1)

checker :: Int -> Int -> Bool
checker x y
    | x > 2 * y = True
    | otherwise = False