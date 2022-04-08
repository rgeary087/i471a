add n1 n2 = n1 + n2

plus = (+)

conc ls1 ls2 = ls1 ++ ls2

add10 = add 10
plus5 = plus 5
concHello = conc "hello"

sumFirst2 [] = 0
sumFirst2 [x] = x
sumFirst2 (x:xs:_) = x + xs

fnFirst2 :: [a] -> (a -> a -> b) -> (a -> a -> b) -> b
fnFirst2 [x,xs,_] f1 f2 =  f2 x xs
fnFirst2 [x, xs] f1 f2 = f1 x xs
fnFirst2 (x : xs) f1 f2= f2 x (head xs)

first (v, _) = v
second (_, v) = v

first3 (v, _, _) = v
snd3 (_, v, _) = v

cartesianProduct ls1 ls2 =
  [ (x, y) | x <- ls1, y <- ls2 ]

cartesianProductIf ls1 ls2 predicate =
  [ (x, y) | x <- ls1, y <- ls2, predicate x y ]

oddEvenPairs n = [(x, y) | x <- [1 .. n], odd x, y <- [1 .. n], even y]
