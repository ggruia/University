{-
class Functor f where
    fmap :: (a -> b) -> f a -> f b

    -- <fmap> ia o functie de la tipul "a" la tipul "b" si o ELEVEAZA
    -- pentru a transforma "functorul a" in "functorul b",
    -- prin maparea valorilor <functorului a> dupa functia (a -> b)

    -- de asemenea, un functor este doar <instanta unui tip de date>
-}



newtype Identity a = Identity a
    deriving (Show, Eq)
instance Functor Identity where
    fmap f (Identity x) = Identity (f x)


data Pair a = Pair a a
    deriving (Show, Eq)
instance Functor Pair where
    fmap f (Pair x x') = Pair (f x) (f x')


data Constant a b = Constant b
    deriving (Show, Eq)
instance Functor (Constant a) where
    fmap f (Constant x) = Constant (f x)


data Two a b = Two a b
    deriving (Show, Eq)
instance Functor (Two a) where
    fmap f (Two x y) = Two x (f y)


data Three a b c = Three a b c
    deriving (Show, Eq)
instance Functor (Three a b) where
    fmap f (Three x y z) = Three x y (f z)

data Three' a b = Three' a b b
    deriving (Show, Eq)
instance Functor (Three' a) where
    fmap f (Three' x y y') = Three' x (f y) (f y')


data Four a b c d = Four a b c d
    deriving (Show, Eq)
instance Functor (Four a b c) where
    fmap f (Four x y z t) = Four x y z (f t)

data Four'' a b = Four'' a a a b
    deriving (Show, Eq)
instance Functor (Four'' a) where
    fmap f (Four'' x x' x'' y) = Four'' x x' x'' (f y)


data Quant a b = Finance | Desk a | Bloor b
    deriving Show
instance Functor (Quant a) where
    fmap f (Bloor y) = Bloor (f y)
    fmap _ (Desk x) = Desk x
    fmap _ Finance = Finance



data LiftItOut f a = LiftItOut (f a)
    deriving Show
instance Functor f => Functor (LiftItOut f) where
    fmap f (LiftItOut fx) = LiftItOut (fmap f fx)


data Parappa f g a = DaWrappa (f a) (g a)
    deriving Show
instance (Functor f, Functor g) => Functor (Parappa f g) where
    fmap f (DaWrappa fx gx) = DaWrappa (fmap f fx) (fmap f gx)


data IgnoreOne f g a b = IgnoringSomething (f a) (g b)
    deriving Show
instance (Functor g) => Functor (IgnoreOne f g a) where
    fmap f (IgnoringSomething fx gy) = IgnoringSomething fx (fmap f gy)


data Notorious g o a t = Notorious (g o) (g a) (g t)
    deriving Show
instance (Functor f) => Functor (Notorious f o a) where
    fmap f (Notorious fx fy fz) = Notorious fx fy (fmap f fz)


data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
    deriving Show
instance Functor GoatLord where
    fmap _ NoGoat = NoGoat
    fmap f (OneGoat x) = OneGoat (f x)
    fmap f (MoreGoats glx gly glz) = MoreGoats (fmap f glx) (fmap f gly) (fmap f glz)


data TalkToMe a = Halt | Print String a | Read (String -> a)
instance Functor TalkToMe where
    fmap _ Halt = Halt
    fmap f (Print s x) = Print s (f x)
    fmap f (Read g) = Read (f . g)
        -- f :: a -> b
        -- g :: String -> a
        -- f . g :: (String -> b)