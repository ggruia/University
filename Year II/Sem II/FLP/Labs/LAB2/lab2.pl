:- set_prolog_flag(answer_write_options,[max_depth(0)]).



% EX 1.
fib(0, X) :-
    X is 1.
fib(1, X) :-
    X is 1.
fib(N, X) :-
    N > 1,
    N1 is N-1,
    N2 is N-2,
    fib(N1, F1),
    fib(N2, F2),
    X is F1 + F2.

fib1(0, _, X, X).
fib1(N, A, B, X) :-
    N > 0,
    Prev is A+B,
    N1 is N-1,
    fib1(N1, B, Prev, X).

fib2(N, X) :-
fib1(N, 0, 1, X).



% EX 2.
println(0, _) :-
    nl.
println(N, S) :-
    N > 0,
    write(S),
    N1 is N-1,
    println(N1, S).

loop(0, _, _).
loop(I, N, S) :-
    I > 0,
    println(N, S),
    I1 is I-1,
    loop(I1, N, S).

square(N, S) :-
    loop(N, N, S).



% EX 3.
% a)
all_a([]).
all_a(['a' | XS]) :-
    all_a(XS).
all_a(['A' | XS]) :-
    all_a(XS).

% b)
trans_a_b([], []).
trans_a_b(['a' | Ta], ['b' | Tb]) :-
    trans_a_b(Ta, Tb).



% EX 4.
% a)
scalarMult(_, [], []).
scalarMult(X, [H | T], [P | R]) :-
    scalarMult(X, T, R),
    P is H * X.

% b)
dot([], [], 0).
dot([H1 | T1], [H2 | T2], R) :-
    P is H1 * H2,
    dot(T1, T2, R1),
    R is P + R1.



% EX 5.
max([], 0).
max([H | T], R) :-
    max(T, R1),
    (H > R1 -> R = H; R = R1).



% EX 6.
revList([], R, R).
revList([H | T], R, R0) :-
    revList(T, R, [H | R0])

palindrome(L) :-
    revList(L, L1, []),
    L == L1.



% EX 7.
remove_duplicates([], []).
remove_duplicates([H | T], R) :-
    member(H, T),
    remove_duplicates(T, R).
remove_duplicates([H | T], [H | R]) :-
    remove_duplicates(T, R).



% EX 8.
replace([], _, _, []).
replace([X | T1], X, Y, [Y | T2]) :-
    replace(T1, X, Y, T2).
replace([H | T1], X, Y, [H | T2]) :-
    replace(T1, X, Y, T2).





/* <examples> Your example queries go here, e.g.

?- fib(1, X).
?- fib(2, X).
?- fib(6, X).

?- fib2(50, X).

?- square(5, '* ').

?- all_a([a,a,a,a]).
?- all_a([a,a,a,b]).
?- all_a([a,a,A,a]).

?- trans_a_b([a,a,a],L).
?- trans_a_b([a,a,a],[b]).
?- trans_a_b(L,[b,b]).

?-scalarMult(3,[2,7,4],Result).

?-dot([2,5,6],[3,4,1],Result).

?-max([4,2,6,8,1],Result).

?-palindrome([r,e,d,i,v,i,d,e,r]).

?- remove_duplicates([a, b, a, c, d, d], List).

?- replace([1, 2, 3, 4, 3, 5, 6, 3], 3, x, List).
*/