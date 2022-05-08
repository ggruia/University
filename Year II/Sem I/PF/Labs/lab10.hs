-- 1.
data Expr =
    Const Int |         -- integer constant
    Expr :+: Expr |     -- addition
    Expr :*: Expr       -- multiplication
    deriving Eq

data Operation = Add | Mult   deriving (Eq, Show)

data Tree =
    Lf Int |                    -- leaf
    Node Operation Tree Tree    -- branch
    deriving (Eq, Show)


-- 1)
instance Show Expr where
    show (Const x) = show x
    show (x :+: y) = "(" ++ show x ++ " + " ++ show y ++ ")"
    show (x :*: y) = "(" ++ show x ++ " * " ++ show y ++ ")"

-- 2)
evalExp :: Expr -> Int
evalExp (Const x) = x
evalExp (x :+: y) = evalExp x + evalExp y
evalExp (x :*: y) = evalExp x * evalExp y

exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
exp2 = (Const 2 :*: (Const 3 :+: Const 4))
exp3 = (Const 4 :+: (Const 3 :*: Const 3))
exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)

test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16

-- 3)
evalArb :: Tree -> Int
evalArb (Lf x) = x
evalArb (Node Add l r) = evalArb l + evalArb r
evalArb (Node Mult l r) = evalArb l * evalArb r

arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6
test22 = evalArb arb2 == 14
test23 = evalArb arb3 == 13
test24 = evalArb arb4 == 16

-- 4)
expToArb :: Expr -> Tree
expToArb (Const x) = (Lf x)
expToArb (x :+: y) = Node Add (expToArb x) (expToArb y)
expToArb (x :*: y) = Node Mult (expToArb x) (expToArb y)


-- 2.

-- 1)
class Collection c where
    empty :: c key value
    singleton :: key -> value -> c key value
    insert :: Ord key => key -> value -> c key value -> c key value
    lookUp :: Ord key => key -> c key value -> Maybe value
    delete :: Ord key => key -> c key value -> c key value
    keys :: c key value -> [key]
    keys c = [k | (k, v) <- toList c]
    values :: c key value -> [value]
    values c = [v | (k, v) <- toList c]
    toList :: c key value -> [(key, value)]
    fromList :: Ord key => [(key,value)] -> c key value
    fromList list = foldr (uncurry insert) empty list


-- 2)
newtype PairList k v = PairList {getPairList :: [(k, v)]}   deriving Show

instance Collection PairList where
    empty = PairList []
    singleton k v = PairList ([(k, v)])

    insert k v (PairList []) = singleton k v
    insert k v c
        | k == key = PairList ((k, v) : xs)
        | otherwise = PairList ((key, val) : toList (insert k v (PairList xs)))
            where ((key, val) : xs) = toList c

    lookUp _ (PairList []) = Nothing
    lookUp k c
        | k == key = Just val
        | otherwise = lookUp k (PairList xs)
            where ((key, val) : xs) = toList c

    delete k c
        | k == key = PairList xs
        | otherwise = insert key val (delete k (PairList xs))
            where ((key, val) : xs) = toList c

    toList c = getPairList c


-- 3)
data SearchTree key value =
    Empty |
    BNode
            (SearchTree key value)  -- elemente cu cheia mai mica
            key                     -- cheia elementului
            (Maybe value)           -- valoarea elementului
            (SearchTree key value)  -- elemente cu cheia mai mare
    deriving Show 
        
instance Collection SearchTree where
    empty = Empty
    singleton k v = BNode Empty k (Just v) Empty

    insert k v Empty = singleton k v
    insert k v (BNode left key value right )
        | k == key = BNode left key (Just v) right
        | k < key = BNode (insert k v left) key value right
        | k > key = BNode left key value (insert k v right) 

    lookUp _ Empty = Nothing
    lookUp k (BNode left key value right)
        | k == key = value
        | k < key = lookUp k left
        | k > key = lookUp k right

    delete k (BNode left key value right)
        | k == key = BNode left key Nothing right
        | k < key = BNode (delete k left) key value right
        | k > key = BNode left key value (delete k right)

    toList Empty = []
    toList (BNode left _ Nothing right ) = toList left ++ toList right
    toList (BNode left key (Just value) right ) = toList left ++ [(key, value)] ++ toList right