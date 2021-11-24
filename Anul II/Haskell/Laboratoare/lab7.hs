-- 1.
data Fruct = Mar String Bool | Portocala String Int

listaFructe = [
    Mar "Ionatan" False,
    Portocala "Sanguinello" 10,
    Portocala "Valencia" 22,
    Mar "Golden Delicious" True,
    Portocala "Sanguinello" 15,
    Portocala "Moro" 12,
    Portocala "Tarocco" 3,
    Portocala "Moro" 12,
    Portocala "Valencia" 2,
    Mar "Golden Delicious" False,
    Mar "Golden" False,
    Mar "Golden" True ]

-- a)
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala s _ ) = elem s ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia (Mar _ _ ) = False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False

-- b)
nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia xs = sum [f | Portocala s f <- xs, ePortocalaDeSicilia (Portocala s f) == True]

test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52

-- c)
nrMereViermi :: [Fruct] -> Int
nrMereViermi xs = sum [1 | Mar s v <- xs, v == True]

test_nrMereViermi = nrMereViermi listaFructe == 2


-- 2.
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa deriving Show

-- a)
vorbeste :: Animal -> String
vorbeste (Pisica _) = "Meow!"
vorbeste (Caine _ _) = "Woof!"

-- b)
rasa :: Animal -> Maybe String
rasa (Caine _ r) = Just r
rasa x = Nothing


-- 3.
data Linie = L [Int] deriving Show
data Matrice = M [Linie] deriving Show

-- a)
testSum :: Linie -> Int -> Bool
testSum (L xs) n = sum xs == n

verifica :: Matrice -> Int -> Bool
verifica (M xss) n = foldr (\line acc -> acc && testSum line n) True xss

test_verif1 = verifica (M [L[1, 2, 3], L[4, 5], L[2, 3, 6, 8], L[8, 5, 3]]) 10 == False
test_verif2 = verifica (M [L[2, 20, 3], L[4, 21], L[2, 3, 6, 8, 6], L[8, 5, 3, 9]]) 25 == True

-- b)
testPosLine :: Linie -> Bool
testPosLine (L xs) = foldr (\x acc -> acc && x > 0) True xs

doarPozN :: Matrice -> Int -> Bool
doarPozN (M xss) n = foldr (\line acc -> acc && testPosLine line) True (filter (\(L xs) -> length xs == n) xss)

testPoz1 = doarPozN (M [L[1, 2, 3], L[4, 5], L[2, 3, 6, 8], L[8, 5, 3]]) 3 == True
testPoz2 = doarPozN (M [L[1, 2, -3], L[4, 5], L[2, 3, 6, 8], L[8, 5, 3]]) 3 == False

-- c)
getLineLength :: Linie -> Int
getLineLength (L xs) = length xs

corect :: Matrice -> Bool
corect (M xss) = all (== head lengths) lengths
    where lengths = map getLineLength xss

testcorect1 = corect (M [L[1, 2, 3], L[4, 5], L[2, 3, 6, 8], L[8, 5, 3]]) == False
testcorect2 = corect (M [L[1, 2, 3], L[4, 5, 8], L[3, 6, 8], L[8, 5, 3]]) == True