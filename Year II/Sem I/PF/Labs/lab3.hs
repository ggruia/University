import Data.Char
import Data.List

-- 1.
countVocaleStr :: String -> Int
countVocaleStr [] = 0
countVocaleStr x
    |(elem (head x) "AaEeIiOoUu") = 1 + countVocaleStr(tail x)
    |otherwise = countVocaleStr(tail x)

nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale xs
    |(head xs == reverse (head xs)) = countVocaleStr(head xs) + nrVocale(tail xs)
    |otherwise = nrVocale(tail xs)

--2.
addEvenX :: Int -> [Int] -> [Int]
addEvenX _ [] = []
addEvenX a xs
    |even(head xs) = head xs : a : addEvenX a (tail xs)
    |otherwise = head xs : addEvenX a (tail xs)

--3.
divizori :: Int -> [Int]
divizori a = [x | x <- [1..a], mod a x == 0]

--4.
listaDiv :: [Int] -> [[Int]]
listaDiv xs = [divizori x | x <- xs]

--5.
inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b xs = [x | x <- xs, elem x [a..b]]

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b xs
    |elem (head xs) [a..b] = head xs : inIntervalRec a b (tail xs)
    |otherwise = inIntervalRec a b (tail xs)

--6.
pozitiveComp :: [Int] -> Int
pozitiveComp xs = sum [1 | a <- xs, a > 0]

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec xs
    |head xs > 0 = 1 + pozitiveRec (tail xs)
    |otherwise = pozitiveRec (tail xs)

--7.
pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp xs = [fst a | a <- (zip xs [0..]), odd(snd a) == True]

        -- !!! tuplu xs = (a, b) <=> fst xs = a; snd xs = b

getPoz :: [Int] -> Int -> [Int]
getPoz [] _ = []
getPoz xs impInd
    |odd (head xs) = impInd : getPoz (tail xs) (impInd + 1)
    |otherwise = getPoz (tail xs) (impInd + 1)

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec xs = getPoz xs 0

--8.
multDigitsComp :: String -> Int
multDigitsComp xs
    |(length [digitToInt(a) | a <- xs, isDigit a == True]) > 0 = product [digitToInt(a) | a <- xs, isDigit a == True]
    |otherwise = 1

        -- !!! product[] = 1

multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec xs
    |isDigit(head xs) == True = digitToInt(head xs) * multDigitsRec(tail xs)
    |otherwise = multDigitsRec(tail xs)