type Name = String

data Value =
    VBool Bool
    | VInt Int
    | VFun (Value -> Value)
    | VError

data Hask =
    HTrue | HFalse
    | HLit Int
    | HVar Name
    | HLam Name Hask
    | HIf Hask Hask Hask
    | Hask :==: Hask
    | Hask :+: Hask
    | Hask :*: Hask
    | Hask :$: Hask
infix 4 :==:
infixl 6 :+:
infixl 7 :*:
infixl 9 :$:

type HEnv = [(Name, Value)]


-- 1.
instance Show Value where
    show (VBool b) = show b
    show (VInt x) = show x
    show (VFun f) = error "HFunctions aren't instances of Show!"
    show (VError) = error "HErrors aren't instances of Show!"


-- 2.
instance Eq Value where
    VBool b1 == VBool b2 = b1 == b2
    VInt x == VInt y = x == y

    VBool b == _ = error "Cannot compare BOOLEAN with non-BOOLEAN!"
    VInt x == _ = error "Cannot compare INT with non-INT!"
    VFun f == _ = error "Cannot compare FUNCTIONS!"
    VError == _ = error "Cannot compare ERRORS!"


-- 3.
hEval :: Hask -> HEnv -> Value
hEval HTrue xss = VBool True
hEval HFalse xss = VBool False

hEval (HIf t v1 v2) xss
    | hEval t xss == VBool True = hEval v1 xss
    | hEval t xss == VBool False = hEval v2 xss
    | otherwise = error "Cannot evaluate IF values!"

hEval (HLit x) xss = VInt x
hEval (HVar s) xss = lookUp xss s
hEval (HLam x exp) xss = VFun (\v -> hEval exp ((x, v):xss))

hEval (x :==: y) xss
    | hEval x xss == hEval y xss = VBool True
    | hEval x xss /= hEval y xss = VBool False
    | otherwise = error "Cannot COMPARE different Data Types!"

hEval (x :+: y) xss = hADD (hEval x xss) (hEval y xss)
    where
        hADD (VInt a) (VInt b) = VInt (a + b)
        hADD _ _ = error "Cannot ADD different Data Types!"

hEval (x :*: y) xss = hMUL (hEval x xss) (hEval y xss)
    where
        hMUL (VInt a) (VInt b) = VInt (a * b)
        hMUL _ _ = error "Cannot MULTIPLY different Data Types!"

hEval (x :$: y) xss = hLAM (hEval x xss) (hEval y xss)
    where
        hLAM (VFun f) x = f x
        hLAM _ _ = error "Invalid LAMBDA argument Types!"

lookUp :: HEnv -> Name -> Value
lookUp [] t = error "Value NOT found!"
lookUp ((s, v):xs) t
    | s == t = v
    | otherwise = lookUp xs t


-- 4.
run :: Hask -> String
run pg = show (hEval pg [])

-- 1)
h0 = (((HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y")))) :$: (HLit 3)) :$: (HLit 4))
h1 = (((HLam "x" (HLam "y" ((HVar "x") :==: (HVar "y")))) :$: HTrue) :$: HFalse)
h2 = (((HLam "x" (HLam "y" ((HVar "x") :==: (HVar "y")))) :$: (HLit 2)) :$: (HLit 2))
h3 = (((HLam "x" (HLam "y" (HLam "z" (((HVar "x") :+: (HVar "y")) :==: (HVar "z")))) :$: (HLit 5)) :$: (HLit 3)) :$: (HLit 8))
h4 = (((HLam "x" (HLam "y" (HLam "z" ((HVar "x") :==: ((HVar "y") :==: (HVar "z"))))) :$: HTrue) :$: (HLit 3)) :$: (HLit 2))

-- 2)
{- am adaugat definitia operatiei de inmultire :*: cu precedenta 7 -}

h5 = (((HLam "x" (HLam "y" ((HVar "x") :*: (HVar "y")))) :$: (HLit 11)) :$: (HLit 13))
h6 = (((HLam "x" (HLam "y" (HLam "z" (((HVar "x") :*: (HVar "y")) :==: (HVar "z")))) :$: (HLit 9)) :$: (HLit 8)) :$: (HLit 72))

-- 3)
{- am adaugat cazurile de eroare pentru cazurile bool/int/fun/error -}

h7 = (((HLam "x" (HLam "y" (HLam "z" (((HVar "x") :*: (HVar "y")) :==: (HVar "z")))) :$: (HLit 9)) :$: (HLit 8)) :$: HTrue)
h8 = (((HLam "x" (HLam "y" (HLam "z" ((HVar "x") :==: ((HVar "y") :+: (HVar "z"))))) :$: HTrue) :$: (HLit 3)) :$: (HLit 2))