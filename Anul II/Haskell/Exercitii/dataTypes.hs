import qualified Data.Map as Map 

-- Algebraic DT
-- example 1.
{- module Shapes   
( Point(..)  
, Shape(..)  
, surface  
, transition
, baseCircle  
, baseRect  
) where -}

data Point = Point Float Float deriving (Show)
data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

baseCircle :: Float -> Shape
baseCircle r = Circle (Point 0 0) r

baseRect :: Float -> Float -> Shape
baseRect w h = Rectangle (Point 0 0) (Point w h)

surface :: Shape -> Float
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = abs(x2 - x1) * abs(y2 - y1)

transition :: Shape -> Float -> Float -> Shape
transition (Circle (Point x y) r) u v = Circle (Point (x + u) (y + v)) r
transition (Rectangle (Point x1 y1) (Point x2 y2)) u v = Rectangle (Point (x1 + u) (y1 + v)) (Point (x2 + u) (y2 + v))


-- Record Syntax
-- example 2.
{-data Person = Person { firstName :: String,
                       lastName :: String,
                       age :: Int,
                       height :: Float,
                       phoneNumber :: String,
                       flavour :: String  
                     } deriving (Show)-}


-- example 3.
data Car a b c = Car { company :: a,
                       model :: b,
                       year :: c
                     } deriving (Show)


-- Type Parameters
--tellCar :: Car -> String  
--tellCar (Car {company = c, model = m, year = y}) = "This " ++ c ++ " " ++ m ++ " was made in " ++ show y 

tellCar2 :: (Show a) => (Show b) => (Show c) => Car a b c -> String
tellCar2 (Car {company = c, model = m, year = y}) = "This " ++ show c ++ " " ++ show m ++ " was made in " ++ show y



data Vector a = Vector a a a deriving (Show)
  
vplus :: (Num t) => Vector t -> Vector t -> Vector t  
vplus (Vector i j k) (Vector l m n) = Vector (i+l) (j+m) (k+n)  
  
vectMult :: (Num t) => Vector t -> t -> Vector t  
vectMult(Vector i j k) m = Vector (i*m) (j*m) (k*m)  
  
scalarMult :: (Num t) => Vector t -> Vector t -> t  
scalarMult(Vector i j k) (Vector l m n) = i*l + j*m + k*n 


-- Derived Instances
-- example 4.
data Person = Person { firstName :: String,
                       lastName :: String,
                       age :: Int  
                     } deriving (Show, Read, Eq)

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday   
           deriving (Eq, Ord, Show, Read, Bounded, Enum)

phoneBook :: [(String,String)]  
phoneBook =
    [("betty","555-2938"),
     ("bonnie","452-2928"),
     ("patsy","493-2928"),
     ("lucille","205-2928"),
     ("wendy","939-8282"),
     ("penny","853-2492")]

--type PhoneBook = [(String,String)]

type PhoneNumber = String  
type Name = String  
type PhoneBook = [(Name,PhoneNumber)] 

inPhoneBook :: Name -> PhoneNumber -> PhoneBook -> Bool  
inPhoneBook name pnumber pbook = (name, pnumber) `elem` pbook


data LockerState = Taken | Free deriving (Show, Eq)  
  
type Code = String  
type LockerMap = Map.Map Int (LockerState, Code)  

lockers :: LockerMap  
lockers = Map.fromList   
    [(100,(Taken,"ZD39I")),
     (101,(Free,"JAH3I")),
     (103,(Free,"IQSA9")),
     (105,(Free,"QOTSA")),
     (109,(Taken,"893JJ")),
     (110,(Taken,"99292"))]

lockerLookup :: Int -> LockerMap -> Either String Code  
lockerLookup lockerNumber map =   
    case Map.lookup lockerNumber map of   
        Nothing -> Left ("Locker number " ++ show lockerNumber ++ " doesn't exist!") 
        Just (state, code) -> if state /= Taken    
                                then Right code  
                                else Left ("Locker " ++ show lockerNumber ++ " is already taken!")