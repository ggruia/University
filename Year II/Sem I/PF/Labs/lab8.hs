import Data.List
import Data.Maybe


type Nume = String
data Prop = Var Nume | F | T | Not Prop | Prop :|: Prop | Prop :&: Prop | Prop :->: Prop | Prop :<->: Prop deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

-- 1.
-- a)
p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

-- b)
p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

-- c)
p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: (Not (Var "P") :&: Not (Var "Q")) :&: (Not (Var "P") :&: Not (Var "R"))

-- 2.
instance Show Prop where
    show (Var nume) = nume
    show (p :|: q) = "(" ++ show p ++ "|" ++ show q ++ ")"
    show (p :&: q) = "(" ++ show p ++ "&" ++ show q ++ ")"
    show (p :->: q) = "(" ++ show p ++ "->" ++ show q ++ ")"
    show (p :<->: q) = "(" ++ show p ++ "<->" ++ show q ++ ")"
    show (Not p) = "(~" ++ show p ++ ")"
    show F = "F"
    show T = "T"

test_ShowProp :: Bool
test_ShowProp = show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

-- Evaluarea expresiilor logice
type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

-- 3.
eval :: Prop -> Env -> Bool
eval (Var x) env = impureLookup x env
eval T _ = True
eval F _ = False
eval (Not p) env = not $ eval p env
eval (p :&: q) env = eval p env && eval q env
eval (p :|: q) env = eval p env || eval q env
eval (p :->: q) env
    | not(eval p env) = True
    | otherwise = eval q env
eval (p :<->: q) env = eval p env == eval q env

test_eval = eval (Var "P" :|: Var "Q") [("P", True), ("Q", False)]

-- 4.
variabile :: Prop -> [Nume]
variabile (Var p) = [p]
variabile (Not p) = nub (variabile p)
variabile (p :&: q) = nub (variabile p ++ variabile q)
variabile (p :|: q) = nub (variabile p ++ variabile q)
variabile (p :->: q) = nub (variabile p ++ variabile q)
variabile (p :<->: q) = nub (variabile p ++ variabile q)
variabile _ = []

test_variabile = variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

-- 5.
envs :: [Nume] -> [[(Nume, Bool)]]
envs [] = []
envs [x] = [[(x, False)], [(x, True)]]
envs (x:xs) = [t:ts | t <- [(x, b) | b <- [False, True]], ts <- envs xs]

test_envs = envs ["P", "Q"] ==
    [[("P", False), ("Q", False)],
    [("P", False), ("Q", True)],
    [("P", True), ("Q", False)],
    [ ("P", True), ("Q", True)]]

-- 6.
satisfiabila :: Prop -> Bool
satisfiabila p = any (eval p) (envs (variabile p))

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q")
test_satisfiabila2 = not (satisfiabila (Not (Var "P") :&: Var "P"))

-- 7.
valida :: Prop -> Bool
valida p = not (satisfiabila (Not p))

test_valida1 = not (valida (Not (Var "P") :&: Var "Q"))
test_valida2 = valida (Not (Var "P") :|: Var "P")

-- 8/9.
tabelAdevar :: Prop -> IO()
tabelAdevar prop = putStrLn (concat (map (++ "\n") tabel))
     where
       vars = variabile prop
       truths = envs vars
       header = concat (map (++ " ") vars ++ ["| "] ++ [show prop])
       guards = concat (replicate (length vars) "- " ++ ["| "] ++ replicate (length (show prop)) "-")
       printBool b = if b then "T" else "F"
       printEval truth = concat ((map ((++ " ").printBool) [snd t | t <- truth]) ++ ["| "] ++ replicate (length (show prop) `div` 2) " " ++ [printBool (eval prop truth)])
       tabel = header : guards : map printEval truths


-- 10.
echivalenta :: Prop -> Prop -> Bool
echivalenta p q = all (eval (p :<->: q)) (envs (nub (variabile p ++ variabile q)))

test_echivalenta1 = (Var "P" :&: Var "Q") `echivalenta` Not (Not (Var "P") :|: Not (Var "Q"))
test_echivalenta2 = not (Var "P" `echivalenta` Var "Q")
test_echivalenta3 = (Var "R" :|: Not (Var "R")) `echivalenta` (Var "Q" :|: Not (Var "Q"))