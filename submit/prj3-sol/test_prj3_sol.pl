:- consult(prj3_sol).


/************************** is_all_greater_than ************************/
:- begin_tests(is_all_greater_than).

test(is_all_greater_than_success) :-
    is_all_greater_than([3, 4, 6], 2).


test(is_all_greater_than_empty) :-
  is_all_greater_than([], 2).


test(is_all_greater_than_failure) :-
  \+ is_all_greater_than([3, 4, 2], 2).

:- end_tests(is_all_greater_than).

/*************************** get_greater_than1 *************************/
:- begin_tests(get_greater_than1).

test(get_greater_than1_all) :-
    findall(X, get_greater_than1([3, 4, 6], 2, X), Zs),
    Zs == [3, 4, 6].

test(get_greater_than1_some) :-
    findall(X, get_greater_than1([1, 3, 4, 2], 2, X), Zs),
    Zs == [3, 4].

test(get_greater_than1_none) :-
    findall(X, get_greater_than1([1, 3, 4, 2], 4, X), Zs),
    Zs == [].

test(get_greater_than1_empty) :-
    findall(X, get_greater_than1([], 4, X), Zs),
    Zs == [].

:- end_tests(get_greater_than1).

/*************************** get_greater_than2 *************************/
:- begin_tests(get_greater_than2).

test(get_greater_than2_all) :-
    findall(X, get_greater_than2([3, 4, 6], 2, X), Zs),
    Zs == [3, 4, 6].

test(get_greater_than2_some) :-
    findall(X, get_greater_than2([1, 3, 4, 2], 2, X), Zs),
    Zs == [3, 4].

test(get_greater_than2_none) :-
    findall(X, get_greater_than2([1, 3, 4, 2], 4, X), Zs),
    Zs == [].

test(get_greater_than2_empty) :-
    findall(X, get_greater_than2([], 4, X), Zs),
    Zs == [].

:- end_tests(get_greater_than2).

/************************* get_all_greater_than ************************/
:- begin_tests(get_all_greater_than).


test(get_all_greater_than_all, [nondet]) :-
    get_all_greater_than([3, 4, 6], 2, Zs),
    Zs == [3, 4, 6].

test(get_all_greater_than_some, [nondet]) :-
    get_all_greater_than([1, 3, 4, 2], 2, Zs),
    Zs == [3, 4].

test(get_all_greater_than_none, [nondet]) :-
    get_all_greater_than([1, 3, 4, 2], 4, Zs),
    Zs == [].

test(get_all_greater_than_empty) :-
    get_all_greater_than([], 4, Zs),
    Zs == [].

:- end_tests(get_all_greater_than).

/************************ get_all_greater_than_tr **********************/
:- begin_tests(get_all_greater_than_tr).

test(get_all_greater_than_tr_all, [nondet]) :-
    get_all_greater_than_tr([3, 4, 6], 2, Zs),
    Zs == [3, 4, 6].

test(get_all_greater_than_tr_some, [nondet]) :-
    get_all_greater_than_tr([1, 3, 4, 2], 2, Zs),
    Zs == [3, 4].

test(get_all_greater_than_tr_none, [nondet]) :-
    get_all_greater_than_tr([1, 3, 4, 2], 4, Zs),
    Zs == [].

test(get_all_greater_than_tr_empty) :-
    get_all_greater_than_tr([], 4, Zs),
    Zs == [].

:- end_tests(get_all_greater_than_tr).

/**************************** split_into_pairs *************************/
:- begin_tests(split_into_pairs).

test(split_into_pairs_empty, [nondet]) :-
    split_into_pairs([], []).

test(split_into_pairs_singleton, [nondet]) :-
    split_into_pairs([a], [[a]]).

test(split_into_pairs_pair, [nondet]) :-
    split_into_pairs([a, b], [[a, b]]).

test(split_into_pairs_even_len, [nondet]) :-
    split_into_pairs([a, b, c, d, e, e, f, f],
		     [[a, b], [c, d], [e, e], [f, f]]).

test(split_into_pairs_odd_len, [nondet]) :-
    split_into_pairs([a, b, c, d, e, e, f, f, g],
		     [[a, b], [c, d], [e, e], [f, f], [g]]).

:- end_tests(split_into_pairs).

/******************************** sum_areas ****************************/
:- begin_tests(sum_areas).

test(sum_areas_empty, [nondet]) :-
    sum_areas([], Area),
    Area =:= 0.

test(sum_areas_rect, [nondet]) :-
    sum_areas([rect(2, 3, 4, 5)], Area),
    Area =:= 20.

test(sum_areas_circ, [nondet]) :-
    sum_areas([circ(2, 3.4, 3)], Area),
    Area =:= pi * 3 * 3.

test(sum_areas_circ2, [nondet]) :-
    sum_areas([circ(2, 3.4, 3), circ(2, 3.4, 2)], Area),
    Area =:= pi * 3 * 3 + pi * 2 * 2.

test(sum_areas_rect_circ2, [nondet]) :-
    sum_areas([circ(2, 3.4, 3), rect(5, 2, 5.5, 3), circ(2, 3.4, 2)], Area),
    Area =:= pi * 3 * 3 + 5.5 * 3 + pi * 2 * 2.

:- end_tests(sum_areas).

/******************************** n_prefix *****************************/
:- begin_tests(n_prefix).

test(n_prefix_1, [nondet]) :-
    n_prefix(1, [1, 2, 3, 4], [1], [2, 3, 4]).
test(n_prefix_exact, [nondet]) :-
    n_prefix(4, [1, 2, 3, 4], [1, 2, 3, 4], []).
test(n_prefix_leftover, [nondet]) :-
    n_prefix(4, [1, 2, 3, 4, 4], [1, 2, 3, 4], [4]).
test(n_prefix_2, [nondet]) :-
    n_prefix(2, [1, 2, 3, 4, 4], [1, 2], [3, 4, 4]).

:- end_tests(n_prefix).

/*************************** split_into_n_lists ************************/
:- begin_tests(split_into_n_lists).

test(split_into_n_lists_empty, [nondet]) :-
    split_into_n_lists(2, [], []).

test(split_into_n_lists_singleton, [nondet]) :-
    split_into_n_lists(2, [a], [[a]]).

test(split_into_n_lists_pair, [nondet]) :-
    split_into_n_lists(2, [a, b], [[a, b]]).

test(split_into_n_lists_even_len, [nondet]) :-
    split_into_n_lists(2, [a, b, c, d, e, e, f, f],
		     [[a, b], [c, d], [e, e], [f, f]]).

test(split_into_n_lists_odd_len, [nondet]) :-
    split_into_n_lists(2, [a, b, c, d, e, e, f, f, g],
		     [[a, b], [c, d], [e, e], [f, f], [g]]).

test(split_into_n_lists_3, [nondet]) :-
    split_into_n_lists(3, [a, b, c, d, e, e, f, f, g],
		     [[a, b, c], [d, e, e], [f, f, g]]).

test(split_into_n_lists_3_leftover, [nondet]) :-
    split_into_n_lists(3, [a, b, c, d, e, e, f, f, g, g, h],
		     [[a, b, c], [d, e, e], [f, f, g], [g, h]]).

:- end_tests(split_into_n_lists).

