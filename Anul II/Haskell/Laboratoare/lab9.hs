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
    fromList xs = foldr (uncurry insert) empty xs
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

    toList xs = getPairList xs

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
    show (Element k (Nothing)) = show k
    show OverLimit = "[]"

-- 4.
{-data BTree key value = BEmpty | BNode [(BTree key value, Element key value)] deriving (Show, Eq)

instance Collection BTree where
    empty = BEmpty
    singleton a b = BNode [(BEmpty, Element a (Just b)), (BEmpty, OverLimit)]

    lookup _ BEmpty = Nothing
    lookup k (BNode list) = go list
        where
            go ((less_than_key, OverLimit): list') = lookup k less_than_key
            go ((less_than_key, Element key o): list')
                | k == key = o
                | k < key = lookup k less_than_key
                | k > key = go list'

            delete _ BEmpty = BEmpty
            delete k (BNode list) = BNode (go list)
                where
                    go ((less_than_key, OverLimit): list') = (delete k less_than_key, OverLimit): list'
                    go ((less_than_key, Element key o): list')
                        | k == key = (less_than_key, Element key Nothing): list'
                        | k < key = ((delete k less_than_key, Element key o): list')
                        | k > key = (less_than_key, Element key o): go list'

            toList BEmpty = []
            toList (BNode list) = go list
                where
                    go ((less_than_key, OverLimit):_) = toList less_than_key
                    go ((less_than_key, e): list') = toList less_than_key ++ elemToList e ++ go list'
            elemToList (Element key Nothing) = []
            elemToList (Element key (Just v)) = [(key, v)]

            insert k v tree = fst (insert' k v tree)
                where
                    insert' k v BEmpty = (singleton k v, True)
                    insert' k v (BNode list) = echilibreaza (go list)

            go ((less_than_key, OverLimit): list') =
                let (less_than_key', e) = insert' k v less_than_key
                    in if e then let (BNode [(less_than_key'', element'),(greater_than_key'', OverLimit)]) = less_than_key' in [(less_than_key'', element'), (greater_than_key'',OverLimit)]
                        else (less_than_key', OverLimit): list'
            go ((less_than_key, Element key o): list')
                | k == key = (less_than_key, Element key (Just v)): list'
                | k < key = let (less_than_key', e) = insert' k v less_than_key
                                in if e then let (BNode [(less_than_key'', element'),(greater_than_key'', OverLimit)]) = less_than_key' in (less_than_key'', element'): (greater_than_key'',Element key o): list'
                                    else (less_than_key', Element key o): list'
                                        | k > key = (less_than_key, Element key o): go list'
            echilibreaza noduri
                | lnod <= 2 * order + 1 = (BNode noduri, False)
                | otherwise = (BNode [( BNode (mici ++ [(mijlocii, OverLimit)]), emijloc), (BNode mari, OverLimit)], True)
                    where
                        lnod = length noduri
                        mici = take order noduri
                        ((mijlocii, emijloc):mari) = drop order noduri-}