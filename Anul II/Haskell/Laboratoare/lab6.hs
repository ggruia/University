import Data.Char
import Data.List


-- 1.
rotate :: Int -> String -> String
rotate x str
    | x >= 0 && x <= length(str) = (drop x str) ++ (take x str)
    | otherwise = error "Numar NEADECVAT de rotiri!"

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

    {- <prop_rotate> verifica functionalitatea metodei <rotate>:
       roteste sirul cu m caractere, unde evita eroarea facand modulo k l
       apoi roteste de inca l - m ori sirul, ceea ce ar trebui sa returneze un sir identic cu cel initial -}

-- 3.
makeKey :: Int -> [(Char, Char)]
makeKey x = zip ['A'..'Z'] (rotate x ['A'..'Z'])

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c xss
    | length x == 0 = c
    | otherwise = snd (head x)
    where x = filter (\(a,b) -> a == c) xss

-- 5.
encipher :: Int -> Char -> Char
encipher x c
    | elem c ['a'..'z'] && (t > z) = toEnum (mod (t - z) 26 + a - 1) :: Char
    | elem c ['A'..'Z'] && (t > z') = toEnum (mod (t - z') 26 + a' - 1) :: Char
    | otherwise = toEnum t :: Char
        where t = fromEnum c + x
              a' = fromEnum 'A'
              a = fromEnum 'a'
              z' = fromEnum 'Z'
              z = fromEnum 'z'

    -- nu mi se spune in cerinta ca s-ar face encipher doar pe ['A'..'Z'] si fara trecere peste alfabet, dar in cazul asta:
encipherBasic :: Int -> Char -> Char
encipherBasic x c =  lookUp c (makeKey x)

-- 6.
normalize :: String -> String
normalize str = map toUpper (filter (`elem` (['A'..'Z'] ++ ['a'..'z'] ++ ['0'..'9'])) str)

    -- ma plictiseam si voiam sa testez daca merge:
normalizeRec :: String -> String
normalizeRec [] = []
normalizeRec (x:xs)
    | isAlpha x = toUpper x : normalize xs
    | isDigit x = x : normalize xs
    | otherwise = normalize xs

-- 7.
encipherStr :: Int -> String -> String
encipherStr x str = map (encipher x) (normalize str)

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey xss = map ((uncurry.flip) (,)) xss
    -- reverseKey xss = map (\(a, b) -> (b, a)) xss

-- 9.
decipher :: Int -> Char -> Char
decipher x c = encipher (26 - mod x 26) c

decipherStr :: Int -> String -> String
decipherStr x xss = map (\c -> if isAlpha c then decipher x c else c) (filter (`elem` (' ' : ['A'..'Z'] ++ ['a'..'z'] ++ ['0'..'9'])) xss)
