import Data.Monoid
import Prelude hiding (elem, null, length, const)


data BinaryTree a =
    Empty
    | Leaf a
    | Node (BinaryTree a) (BinaryTree a)
    deriving Show

foldTree :: ( a -> b -> b ) -> b -> BinaryTree a -> b
foldTree f i Empty = i 
foldTree f i ( Leaf x ) = f x i
foldTree f i (Node l r ) = foldTree f ( foldTree f i r ) l

myTree = Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))
myTreeM = Node (Node (Leaf (Sum 1)) (Leaf (Sum 2))) (Node (Leaf (Sum 3)) (Leaf (Sum 4)))

instance Foldable BinaryTree where
  foldr = foldTree

-- foldMap :: Monoid m => (a -> m) -> t a -> m
-- foldr :: (a -> b -> b ) -> b -> t a -> b
-- (==) :: a -> a -> Bool 



-- 1.
elem :: (Foldable t, Eq a) => a -> t a -> Bool
-- elem k xs = foldr (\x acc -> acc || k == x) False xs
elem x xs = getAny (foldMap (\y -> Any (x == y)) xs)

null :: (Foldable t) => t a -> Bool
-- null xs = foldr (\x acc -> False) True xs
null xs = getAll (foldMap (\x -> All False) xs)

length :: (Foldable t) => t a -> Int
-- length xs = foldr (\x acc -> acc + 1) 0 xs
length xs = getSum (foldMap (\x -> Sum 1) xs)

toList :: (Foldable t) => t a -> [a]
-- toList xs = foldr (:) [] xs
toList xs = foldMap (\x -> [x]) xs

fold :: (Foldable t, Monoid m) => t m -> m
fold xs = foldMap id xs


-- test functions
-- elem
elemtest1 = elem 3 []
elemtest2 = elem 3 [1, 2]
elemtest3 = elem 3 [1..5]
elemtest4 = elem 3 [1..]
elemtest5 = elem 'n' "string"
elemtest6 = elem 'a' ""
elemtest7 = elem "string1" ["string1", "string2", "string3"]

-- null
nulltest1 = null []
nulltest2 = null [1]
nulltest3 = null [1..]
nulltest4 = null ""
nulltest5 = null "string"

-- length
lengthtest1 = length []
lengthtest2 = length [1, 2, 3]
lengthtest3 = length ""
lengthtest4 = length "string"

-- toList
toListtest1 = toList Nothing
toListtest2 = toList (Just 42)
toListtest3 = toList [1, 2, 3]

-- fold
foldtest1 = fold [[1, 2, 3], [4, 5], [6], []]
foldtest2 = fold myTreeM


-- 2.
data Constant a b = Constant b
    deriving Show
instance Foldable (Constant a) where
    foldMap f (Constant x) = f x
const = Constant 3

data Two a b = Two a b
    deriving Show
instance Foldable (Two a) where
    foldMap f (Two x y) = f y
two = Two 'a' 5

data Three a b c = Three a b c
    deriving Show
instance Foldable (Three a b) where
    foldMap f (Three x y z) = f z
three = Three 1 'a' True

data Three' a b = Three' a b b
    deriving Show
instance Foldable (Three' a) where
    foldMap f (Three' x y y') = (f y) <> (f y')
three' = Three' 'z' 5 9

data Four' a b = Four' a b b b
    deriving Show
instance Foldable (Four' a) where
    foldMap f (Four' x y y' y'') = (f y) <> (f y') <> (f y'')
four' = Four' 's' 2 5 8

data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
    deriving Show
instance Foldable GoatLord where
    foldMap f NoGoat = mempty
    foldMap f (OneGoat x) = f x
    foldMap f (MoreGoats glx gly glz) = (foldMap f glx) <> (foldMap f gly) <> (foldMap f glz)
goatlord1 = NoGoat
goatlord2 = OneGoat 5
goatlord3 = MoreGoats (OneGoat 5) NoGoat (MoreGoats (OneGoat 1) (OneGoat 6) NoGoat)