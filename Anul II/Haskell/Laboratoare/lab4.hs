-- 1.
factori :: Int -> [Int]
factori n = [x | x <- [1..n], rem n x == 0]

-- 2.
prim :: Int -> Bool
prim n
    |n == 1 = False
    |length(factori n) == 2 = True
    |otherwise = False

-- 3.
numerePrime :: Int -> [Int]
numerePrime n = [x | x <- [2..n], prim x == True]

-- 4.
myzip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
myzip3 (x:xs) (y:ys) (z:zs) = 
    (x, y, z) : myzip3 xs ys zs

-- 5.
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and [a <= b | (a, b) <- zip (x:xs) xs]

-- 6.
ordonataNat1 :: [Int] -> Bool
ordonataNat1 [] = True
ordonataNat1 [x] = True
ordonataNat1 (x:y:xs)
    |x <= y = ordonataNat1 (y:xs)
    |otherwise = False

-- 7.
ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata [] rel = True
ordonata [x] rel = True
ordonata (x:xs) rel = and [rel a b | (a, b) <- zip (x:xs) xs]

-- 8.
infixr 6 *<*
(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
(a, b) *<* (c, d)
    |(a + c) > (b + d) = True
    |otherwise = False

-- 9.
compuneList :: (b -> c) -> [(a -> b)] -> [( a -> c)]
compuneList f fxs = [f.g | g <- fxs]

-- 10.
aplicaList :: a -> [(a -> b)] -> [b]
aplicaList x fxs = [n x | n <- fxs]