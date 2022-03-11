quadratic-roots(A, B, C, Z) :- 
    Z is (-B+sqrt(B*B - 4*A*C))/(2*A);Z is (-B-sqrt(B*B - 4*A*C))/(2*A).

quadratic-roots2(A, B, C, Z) :- 
    quadratic-roots2AUX(A, B, sqrt(B*B - 4*A*C), Z).


quadratic-roots2AUX(A, B, DISC, Z) :- 
    Z is (-B+DISC)/(2*A);Z is (-B-DISC)/(2*A).

sum_lists([], 0).
sum_lists([_|Ns], Sum):-
  sum_lists(Ns, NsSum),
  Sum is NsSum + 1.

sum_lengths([], 0).
sum_lengths([S|Ss], Sum):-
    sum_lengths(Ss, SsSum),
    V = sum_lists(S, V),
    Sum is V + SsSum.
