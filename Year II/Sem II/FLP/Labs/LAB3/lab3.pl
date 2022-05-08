:- set_prolog_flag(answer_write_options,[max_depth(0)]).



% EX 0. Prolog gaseste raspunsurile pentru operatorul "=" printr-un arbore de cautare.

/* !!! IMPORTANT PT MINE !!!
loop(0, []).
loop(I, [x | V]) :-
    I1 is I - 1,
    loop(I1, V).*/



% EX 1. "Crossword puzzle"
word(abalone, a,b,a,l,o,n,e).
word(abandon, a,b,a,n,d,o,n).
word(enhance, e,n,h,a,n,c,e).
word(anagram, a,n,a,g,r,a,m).
word(connect, c,o,n,n,e,c,t).
word(elegant, e,l,e,g,a,n,t).

crosswd(V1, V2, V3, H1, H2, H3) :-
    word(V1, _, V1H1, _, V1H2, _, V1H3, _),
   	word(V2, _, V2H1, _, V2H2, _, V2H3, _),
   	word(V3, _, V3H1, _, V3H2, _, V3H3, _),
   	word(H1, _, V1H1, _, V2H1, _, V3H1, _),
   	word(H2, _, V1H2, _, V2H2, _, V3H2, _),
   	word(H3, _, V1H3, _, V2H3, _, V3H3, _),
    V1 \== H1,
    V2 \== H2,
    V3 \== H3.



% EX 2. "Database"
born(jan, date(20,3,1977)).
born(jeroen, date(2,2,1992)).
born(joris, date(17,3,1995)).
born(jelle, date(1,1,2004)).
born(joan, date(24,12,0)).
born(joop, date(30,4,1989)).
born(jannecke, date(17,3,1993)).
born(jaap, date(16,11,1995)).

year(Y, P) :-
    born(P, date(_, _, Y)).

before(date(D1, M1, Y1), date(D2, M2, Y2)) :-
    Y1 < Y2;
    Y1 = Y2, M1 < M2;
    Y1 = Y2, M1 = M2, D1 < D2.

older(P1, P2) :-
    born(P1, D1),
    born(P2, D2),
    before(D1, D2).



% EX 3. "Maze"
/*connected(1,2).
connected(3,4).
connected(5,6).
connected(7,8).
connected(9,10).
connected(12,13).
connected(13,14).
connected(15,16).
connected(17,18).
connected(19,20).
connected(4,1).
connected(6,3).
connected(4,7).
connected(6,11).
connected(14,9).
connected(11,15).
connected(16,12).
connected(14,17).
connected(16,19).*/

connected(1,2).
connected(2,1).
connected(1,3).
connected(3,4).

path(S, T) :-
    move(S, T, [S]).

move(S, T, _) :- 
    connected(S, T).
move(S, T, V) :-
    connected(S, N),
    \+ member(N, V),
    move(N, T, [N | V]).



% EX 4. "Numere naturale"
successor(N, R) :-
    R = [x | N].

add([], L, L).
add([H | T], L, [H | R]) :-
    add(T, L, R).

times([], _, []).
times([_ | T], L, R) :-
    times(T, L, R1),
    add(L, R1, R).



% EX 5. "N-th element"
element_at([X | _], 0, X) .
element_at([_ | T], N, X) :-
    N > 0 ,
  	N1 is N - 1 ,
  	element_at(T, N1, X).



% EX 6. "Animale"
animal(alligator). 
animal(tortue).
animal(caribou).
animal(ours).
animal(cheval).
animal(vache).
animal(lapin).

mutant(X) :-
    animal(A),
    animal(B),
    A \== B,
    name(A, La),
    name(B, Lb),
    merge(La, Lb, R),
    name(X, R).
    
merge(A, B, R) :-
    combine(A, B, R).
merge([H | T1], [G | T2], [H | T3]) :-
    merge(T1, [G | T2], T3).

combine([H], [H | T], [H | T]).
combine([H | T1], [H | T2], [H | T3]) :-
    combine(T1, T2, T3).



/* <examples>
?- X = c.
?- f(X, g(Y, Z)) = f(c, g(X, Y)).
?- f(X, g(Y, f(X))) = f(c, g(X, Y)).

?- crosswd(V1, V2, V3, H1, H2, H3).

?- year(1995, Person).

?- before(date(31,1,1990), date(7,7,1990)).

?- older(jannecke,X).

?- path(5, 10).
?- path(1, X).
?- path(X, 13).

?- successor([x,x,x], Result).
?- successor([], Result).

?- add([x, x], [x, x, x, x], Result).

?- times([x, x], [x, x, x, x], Result).

?- element_at([tiger, dog, teddy_bear, horse, cow], 3, X).
?- element_at([a, b, c, d], 27, X).

?- name(alligator, L).
?- name(A, [97, 108, 108, 105, 103, 97, 116, 111, 114]).

?- mutant(X).
*/