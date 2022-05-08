-- 1.
poly2 :: Double -> Double -> Double -> Double -> Double
poly2 a b c x = a*x^2+b*x+c

-- 2.
eeny :: Integer -> String
eeny a 
    |even a == True = "eeny"
    |otherwise = "meeny"

-- 3.
fizzbuzz :: Integer -> String
fizzbuzz a
    |a `mod` 15 == 0 = "FizzBuzz"
    |a `mod` 3 == 0 = "Fizz"
    |a `mod` 5 == 0 = "Buzz"
    |otherwise = ""

fizzbuzz2 :: Integer -> String
fizzbuzz2 a =
    if a `mod` 15 == 0 then "FizzBuzz"
        else if a `mod` 3 == 0 then "Fizz"
        else if a `mod` 5 == 0 then "Buzz"
        else ""

-- 4.
tribonacci :: Integer -> Integer
tribonacci n
    |n == 1 = 1
    |n == 2 = 1
    |n == 3 = 2
    |otherwise = tribonacci (n - 1) + tribonacci (n - 2) + tribonacci (n - 3)

tribonacci2 :: Integer -> Integer
tribonacci2 n =
    if n == 1 then 1
        else if n == 2 then 1
        else if n == 3 then 2
        else tribonacci (n - 1) + tribonacci (n - 2) + tribonacci (n - 3)

-- 5.
binomial :: Integer -> Integer -> Integer
binomial n k
    |k == 0 = 1
    |n == 0 = 0
    |otherwise = binomial (n-1) k + binomial (n-1) (k-1)

-- 6.
verifL :: [Int] -> Bool
verifL a = 
    if even (length a) == True
        then True
        else False

takefinal :: [a] -> Int -> [a]
takefinal a b =
    if length a < b
        then a
        else drop  (length a - b) a

remove :: [Int] -> Int -> [Int]
remove a b
    |b >= length a = a
    |otherwise = (take b a) ++ (drop (b+1) a)

-- 7.
myreplicate :: Int -> Int -> [Int]
myreplicate n v
    |n == 0 = []
    |otherwise = v : myreplicate (n-1) v

sumImp :: [Int] -> Int
sumImp [] = 0
sumImp a
    |(head a) `mod` 2 == 1 = head a + sumImp (drop 1 a)
    |otherwise = sumImp (drop 1 a)

totalLen :: [String] -> Int
totalLen a
    |length a == 0 = 0
    |otherwise = (
        if(head (head a) == 'A')
            then length (head a)
            else 0
        ) + totalLen (tail a)