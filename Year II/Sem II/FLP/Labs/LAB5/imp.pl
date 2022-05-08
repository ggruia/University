:- op(100, xf, {}).
:- op(1100, yf, ;).


aexp(I) :- integer(I).
aexp(X) :- atom(X).
aexp(A1 + A2) :-
    aexp(A1),
    aexp(A2).
aexp(A1 - A2) :-
    aexp(A1),
    aexp(A2).
aexp(A1 * A2) :-
    aexp(A1),
    aexp(A2).


bexp(true).
bexp(false).
bexp(and(B1, B2)) :-
    bexp(B1),
    bexp(B2).
bexp(A1 =< A2) :-
    aexp(A1),
    aexp(A2).
bexp(A1 >= A2) :-
    aexp(A1),
    aexp(A2).
bexp(A1 == A2) :-
    aexp(A1),
    aexp(A2).
bexp(not(B)) :-
    bexp(B).
bexp(and(B1, B2)) :-
    bexp(B1),
    bexp(B2).
bexp(or(B1, B2)) :-
    bexp(B1),
    bexp(B2).


stmt(skip).
stmt(X = A) :-
    atom(X),
    aexp(A).
stmt({S}) :-
    stmt(S).
stmt(S1; S2) :-
    stmt(S1),
    stmt(S2).
stmt(if(B,S1,S2)) :-
    bexp(B),
    stmt(S1),
    stmt(S2).
stmt(while(B,S)) :-
    bexp(B),
    stmt(S).


program(S,A) :-
    stmt(S),
    aexp(A).



test0 :- program(
    {
        x = 10 ;
        sum = 0;
        while(0 =< x,
        {
            sum = sum + x;
            x = x-1
        })
    },
    sum).