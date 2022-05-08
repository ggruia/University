get(S,X,I) :- member(vi(X,I),S).
get(_,_,0).

set(S,X,I,[vi(X,I)|S1]) :- del(S,X,S1).

del([vi(X,_)|S],X,S).
del([H|S],X,[H|S1]) :- del(S,X,S1) .
del([],_,[]).


smallstepA(X,S,I,S) :-
    atom(X),
    get(S,X,I).
smallstepA(I1 + I2,S,I,S) :-
    integer(I1),
    integer(I2),
    I is I1 + I2.
smallstepA(I + A1,S,I + A2,S) :-
    integer(I),
    smallstepA(A1,S,A2,S).
smallstepA(A1 + A,S,A2 + A,S) :-
    smallstepA(A1, S, A, S),
    smallstepA(A, S, A2, S).