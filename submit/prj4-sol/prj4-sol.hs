import Unit  -- crude assertions for unit tests
import Control.Comonad.Traced (All(getAll))

-------------------------- isAllGreaterThan1 ----------------------------

-- #1: 5-points
-- isAllGreaterThan1 ns n: return True iff all ns are greater than n.
-- Restriction: must be implemented using recursion.
-- Hint: use infix > and short-circuit &&

isAllGreaterThan1 :: Ord n => [n] -> n -> Bool

testIsAllGreaterThan1 = do
  assertTrue "isAllGreaterThan1 empty" (isAllGreaterThan1 [] 4)
  assertTrue "isAllGreaterThan1 all true" (isAllGreaterThan1 [5, 7] 4)
  assertFalse "isAllGreaterThan1 last fail" (isAllGreaterThan1 [5, 7, 4] 4)

--isAllGreaterThan1 _ _ = True  -- TODO
isAllGreaterThan1 [] n = True
isAllGreaterThan1 (x:xs) n = (x > n) && isAllGreaterThan1 xs n


-------------------------- isAllGreaterThan2 ----------------------------

-- #2 5-points
-- isAllGreaterThan2 ns n: return True iff all ns are greater than n.
-- Restriction: must be implemented using Haskell all
-- <https://hackage.haskell.org/package/base-4.16.1.0/docs/Prelude.html#v:all>
-- Hint: Use partially applied > as function argument to all

isAllGreaterThan2 :: Ord n => [n] -> n -> Bool

testIsAllGreaterThan2 = do
  assertTrue "isAllGreaterThan2 empty" (isAllGreaterThan2 [] 4)
  assertTrue "isAllGreaterThan2 all true" (isAllGreaterThan2 [5, 7] 4)
  assertFalse "isAllGreaterThan2 last fail" (isAllGreaterThan2 [5, 7, 4] 4)

isAllGreaterThan2 ns n = all (>n) ns -- TODO

-------------------------- isAllGreaterThan3 ---------------------------

-- #3: 10-points
-- isAllGreaterThan3 ns n: return list contain those ns > n.
-- Restriction: must be implemented using foldl
-- <https://hackage.haskell.org/package/base-4.16.1.0/docs/Data-List.html#v:foldl>
-- Hint: use short-circuit &&; define a local auxiliary function for
-- the argument to foldl.

isAllGreaterThan3 :: Ord n => [n] -> n -> Bool

testIsAllGreaterThan3 = do
  assertTrue "isAllGreaterThan3 empty" (isAllGreaterThan3 [] 4)
  assertTrue "isAllGreaterThan3 all true" (isAllGreaterThan3 [5, 7] 4)
  assertFalse "isAllGreaterThan3 last fail" (isAllGreaterThan3 [5, 7, 4] 4)

isAllGreaterThan3 ns n = foldl (\ x y -> x && (y>n)) True ns  -- TODO

--------------------------- mapToGreaterThan ----------------------------

-- #4: 5-points
-- mapToGreaterThan list n : return list of Bool with each element
-- of returned list True iff corresponding element in list > n.
-- Restriction: must use map
-- <https://hoogle.haskell.org/?hoogle=map&scope=set%3Astackage>
-- Hint: Use map with a lambda function (\element -> elementExpr)

mapToGreaterThan :: Ord a => [a] -> a -> [Bool]

testMapToGreaterThan = do
  assertEq "mapToGreaterThan empty" (mapToGreaterThan [] 3) []
  assertEq "mapToGreaterThan all"
           (mapToGreaterThan [4, 5, 4] 3) [True, True, True]
  assertEq "mapToGreaterThan none"
           (mapToGreaterThan [4, 5, 4] 5) [False, False, False]
  assertEq "mapToGreaterThan some"
           (mapToGreaterThan [4, 5, 6] 5) [False, False, True]

mapToGreaterThan xs n = map (> n) xs -- TODO

-------------------------- getAllGreaterThan1 ---------------------------

-- #5: 10-points
-- getAllGreaterThan1 ns n: return list contain those ns > n.
-- Restriction: must be implemented using recursion
-- Hint: use guards for the recursive case

getAllGreaterThan1 :: Ord n => [n] -> n -> [n]


testGetAllGreaterThan1 = do
  assertEq "getAllGreaterThan1 empty" (getAllGreaterThan1 [] 4) []
  assertEq "getAllGreaterThan1 all true" (getAllGreaterThan1 [5, 7] 4) [5, 7]
  assertEq "getAllGreaterThan1 not last" (getAllGreaterThan1 [5, 7, 4] 4) [5, 7]

--getAllGreaterThan1 _ _ = [] -- TODO
getAllGreaterThan1 [] n = []
getAllGreaterThan1 (x:xs) n 
  | x > n = x:(getAllGreaterThan1 xs n)
  |otherwise = getAllGreaterThan1 xs n
-------------------------- getAllGreaterThan2 ---------------------------

-- #6: 5-points
-- getAllGreaterThan2 ns n: return list contain those ns > n.
-- Restriction: must be implemented using filter
-- <https://hackage.haskell.org/package/base-4.16.1.0/docs/Data-List.html#v:filter>

getAllGreaterThan2 :: Ord n => [n] -> n -> [n]

testGetAllGreaterThan2 = do
  assertEq "getAllGreaterThan2 empty" (getAllGreaterThan2 [] 4) []
  assertEq "getAllGreaterThan2 all true" (getAllGreaterThan2 [5, 7] 4) [5, 7]
  assertEq "getAllGreaterThan2 not last" (getAllGreaterThan2 [5, 7, 4] 4) [5, 7]

--getAllGreaterThan2 ns n = [] -- TODO
getAllGreaterThan2 ns n = filter (> n) ns

-------------------------- splitIntoLists2 ------------------------------

-- #7: 10-points
-- splitIntoLists2 list : return list containing 2-element sublists
-- containing the elements of list in order.  If the length of list
-- is odd, then the last element of the returned list should be a
-- single element list containing the last element of list.
-- Hint: use pattern matching to distinguish lists of different lengths.

splitIntoLists2 :: [a] -> [[a]]

testSplitIntoLists2 = do
  -- note: using (assertEq "..." (splitIntoLists2 []) []) does not type check
  assertTrue "splitIntoLists2 empty" (null (splitIntoLists2 []))
  assertEq "splitIntoLists2 1-element" (splitIntoLists2 [2]) [[2]]
  assertEq "splitIntoLists2 2-elements" (splitIntoLists2 [1, 2]) [[1, 2]]
  assertEq "splitIntoLists2 3-elements"
            (splitIntoLists2 [2, 1, 4]) [[2, 1], [4]]
  assertEq "splitIntoLists2 5-elements"
            (splitIntoLists2 [2, 2, 2, 1, 4]) [[2, 2], [2, 1], [4]]
  assertEq "splitIntoLists2 6-elements"
            (splitIntoLists2 [2, 2, 2, 1, 4, 1]) [[2, 2], [2, 1], [4, 1]]

--splitIntoLists2 _ = [] -- TODO
splitIntoLists2 [] = []
splitIntoLists2 [x] = [x]:(splitIntoLists2 [])
splitIntoLists2 [x1,x2] = [x1,x2]:(splitIntoLists2 [])
splitIntoLists2 (x:x1:x2) = [x,x1]:(splitIntoLists2 x2)
-------------------------- splitIntoPairs -------------------------------

-- #8: 15-points
-- splitIntoPairs list: returns Nothing if length of list is odd,
-- otherwise it returns Just pairs where pairs is a list containing 2-element
-- tuples of the elements of list in order. .
-- Hint: to return a Maybe x each returned value must be constructed using
-- either a Nothing or a Just x. Note that since recursive calls will
-- return a Maybe x, use a case expression on the recursive call return value
-- to match either Nothing or Just x.

splitIntoPairs :: [a] -> Maybe [(a, a)]

testSplitIntoPairs = do
  -- note: using (assertEq "..." (splitIntoPairs []) (Just []))
  -- does not type check
  assertTrue "splitIntoPairs empty"
             (case (splitIntoPairs []) of
               (Just x) -> null x
               otherwise -> False)
  assertEq "splitIntoPairs 1-element" (splitIntoPairs [2]) Nothing
  assertEq "splitIntoPairs 2-elements" (splitIntoPairs [1, 2]) (Just [(1, 2)])
  assertEq "splitIntoPairs 3-elements"
            (splitIntoPairs [2, 1, 4]) Nothing
  assertEq "splitIntoPairs 5-elements"
            (splitIntoPairs [2, 2, 2, 1, 4]) Nothing
  assertEq "splitIntoPairs 6-elements"
            (splitIntoPairs [2, 2, 2, 1, 4, 1]) (Just [(2, 2), (2, 1), (4, 1)])

consOnMaybe _ Nothing = Nothing 
consOnMaybe x (Just xs) = Just (x: xs)

--splitIntoPairs _ = Nothing -- TODO
splitIntoPairs [] = Just []
splitIntoPairs [x] = Nothing
splitIntoPairs  [x1,x2] = consOnMaybe (x1,x2) (splitIntoPairs [])
splitIntoPairs (x:x1:x2) = consOnMaybe (x,x1) (splitIntoPairs x2)
-------------------------------- nPrefix --------------------------------

-- #9: 20-points
-- nPrefix list n: returns a pair (nPrefix, rest) where nPrefix is
-- a list containing the first n elements of list and rest are the
-- remaining elements of list.  It is assumed that n >= 0.
-- Hint: Distinguish  length list < n and otherwise.  In the
-- latter case use a local recursive auxiliary function to
-- split apart the first n-elements and the rest of list.

nPrefix :: [a] -> Int -> ([a], [a])

testNPrefix = do
  -- note: using (assertEq "..." (nPrefix [] 4) ([], [])) does not type check
  assertTrue "testNPrefix empty"
              (let pair = (nPrefix [] 4) in
                   (null (fst pair)) && (null (snd pair)))
  assertEq "testNPrefix 0" (nPrefix [1, 2, 3, 4] 0) ([], [1, 2, 3, 4])
  assertEq "testNPrefix 1" (nPrefix [1, 2, 3, 4] 1) ([1], [2, 3, 4])
  assertEq "testNPrefix 2" (nPrefix [1, 2, 3, 4] 2) ([1, 2], [3, 4])
  assertEq "testNPrefix 5" (nPrefix [1, 2, 3, 4] 5) ([], [1, 2, 3, 4])

--nPrefix _ _ = ([], []) -- TODO
nPrefix x 0 = ([], x)
nPrefix x n 
  | length x < n = ([], x)
  | otherwise = (take n x, drop n x)




----------------------------- splitIntoNLists ---------------------------

-- #10: 15-points
-- splitIntoNLists list n: returns a list of n-element lists containing
-- the elements of list in order; if the length of list is not divisible
-- by n, the last element of the returned list will contain the leftover
-- elements.  Assume n > 0.
-- Hint: use nPrefix; distinguish 3 cases for length of rest returned
-- by nPrefix: 0, < n, otherwise. 

splitIntoNLists :: [a] -> Int -> [[a]]

testSplitIntoNLists = do
  -- note: using (assertEq "..." (splitIntoNLists [] 2) []) does not type check
  assertTrue "splitIntoNLists empty" (null (splitIntoNLists [] 2))
  assertEq "splitIntoNLists 3-elements 2"
           (splitIntoNLists [1, 2, 3] 2) [[1, 2], [3]]
  assertEq "splitIntoNLists 3-elements 1"
           (splitIntoNLists [1, 2, 3] 1) [[1], [2], [3]]
  assertEq "splitIntoNLists 3-elements 3"
           (splitIntoNLists [1, 2, 3] 3) [[1, 2, 3]]
  assertEq "splitIntoNLists 4-elements 2"
           (splitIntoNLists [1, 2, 3, 4] 2) [[1, 2], [3, 4]]
  assertEq "splitIntoNLists 5-elements 2"
           (splitIntoNLists [1, 2, 3, 4, 5] 2) [[1, 2], [3, 4], [5]]
  assertEq "splitIntoNLists 4-elements 3"
           (splitIntoNLists [1, 2, 3, 4] 3) [[1, 2, 3], [4]]

--splitIntoNLists _ _ = [] -- TODO
splitIntoNLists [] _ = []
splitIntoNLists x n 
  |length x > n = (take n x):(splitIntoNLists (drop n x) n)
  |length x <= n = [x]
splitIntoNLists x _ = [x]
------------------------------ Run All Tests ----------------------------

testAll = do
  testIsAllGreaterThan1
  testIsAllGreaterThan2
  testIsAllGreaterThan3
  testMapToGreaterThan
  testGetAllGreaterThan1
  testGetAllGreaterThan2
  testSplitIntoLists2
  testSplitIntoPairs
  testNPrefix
  testSplitIntoNLists
