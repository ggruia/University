-- 1.
foldZeros :: [Int] -> [Int]
foldZeros xs = dispatch (compress xs)

compress :: [Int] -> [Int]
compress [] = []
compress [a] = [a]
compress [a, b] = if sum [a, b] == 0 then [0] else [a, b]
compress [a, b, c]
    | sum [a, b, c]== 0 = [0]
    | sum [a, b]== 0 = [0, c]
    | sum [b, c] == 0 = [a, 0]
    | otherwise = [a, b, c]
compress (x:y:xs)
    | sum[x, y] == 0 = compress (y:xs)
    | otherwise = x : compress (y:xs)

dispatch :: [Int] -> [Int]
dispatch [] = []
dispatch [a] = [a]
dispatch [a, b] = if sum [a, b] == 1 then [1] else [a, b]
dispatch (x:y:xs)
    | x == 0 && y == 1 = dispatch(y:xs)
    | x == 1 && y == 0 = dispatch(x:xs)
    | otherwise = x : dispatch(y:xs)

-- 2.
findPalindrome :: [String] -> Bool
findPalindrome (x:xss) = undefined
