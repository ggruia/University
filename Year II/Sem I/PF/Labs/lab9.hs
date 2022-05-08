import Prelude hiding (lookup)
import qualified Data.List as List

-- 0.
class Collection myMap where
    empty :: myMap key value
    singleton :: key -> value -> myMap key value
    insert :: Ord key => key -> value -> myMap key value -> myMap key value
    lookup :: Ord key => key -> myMap key value -> Maybe value
    delete :: Ord key => key -> myMap key value -> myMap key value
    keys :: myMap key value -> [key]
    keys xs = [fst x | x <- toList xs]
    values :: myMap key value -> [value]
    values xs = [snd x | x <- toList xs] 
    fromList :: Ord key => [(key, value)] -> myMap key value
    fromList = foldr (uncurry insert) empty
    toList :: myMap key value -> [(key, value)]

-- 1.
newtype PairList key value = PairList {getPairList :: [(key, value)]}

instance Collection PairList where
    empty = PairList []
    singleton a b = PairList [(a, b)]

    insert a b xs = PairList (getPairList xs ++ [(a, b)])

    lookup key xs = search key (getPairList xs)
        where
            search _ [] = Nothing
            search k (x:xss)
                | fst x == k = Just (snd x)
                | otherwise = lookup k xs

    delete key xs = PairList (del key (getPairList xs))
        where
            del k (x:xss)
                | fst x == k = del k xss
                | otherwise = x : del k xss

    toList = getPairList

-- 2.
data SearchTree key value = Empty | Node
                                        (SearchTree key value)  -- elemente cu cheia mai mica
                                        key                     -- cheia elementului
                                        (Maybe value)           -- valoarea elementului
                                        (SearchTree key value)  -- elemente cu cheia mai mare

instance Collection SearchTree
    where
        empty = Empty
        singleton key val = Node Empty key (Just val) Empty

        insert key val Empty = singleton key val
        insert k v (Node low key val high)
            | k == key = Node low key (Just v) high
            | k < key = Node (insert k v low) key val high
            | k > key = Node low key val (insert k v high) 

        lookup _ Empty = Nothing
        lookup k (Node low key val high)
            | k == key = val
            | k < key = lookup k low
            | k > key = lookup k high

        delete k (Node low key val high)
            | k == key = Node low key Nothing high
            | k < key = Node (delete k low) key val high
            | k > key = Node low key val (delete k high)
            
        toList Empty = []
        toList (Node low _ Nothing high ) = toList low ++ toList high
        toList (Node low key (Just value) high ) = toList low ++ [(key, value)] ++ toList high

-- 3.
data Element k v = Element k (Maybe v) | OverLimit

-- a)
instance Eq k => Eq (Element k v) where
    (Element k1 v1) == (Element k2 v2) = k2 == k1
    (Element k v) == OverLimit = False
    OverLimit == (Element k v) = False
    OverLimit == OverLimit = True

-- b)
instance Ord k => Ord (Element k v) where
    (Element k1 v1) <= (Element k2 v2) = k1 <= k1
    OverLimit <= (Element k v) = False
    (Element k v) <= OverLimit = True

-- c)
instance (Show k, Show v) => Show (Element k v) where
    show (Element k (Just v)) = "("++ show k ++ ","++ show v++")"
    show (Element k Nothing) = show k
    show OverLimit = "[]"