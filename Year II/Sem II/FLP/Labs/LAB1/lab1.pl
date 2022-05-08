:- set_prolog_flag(answer_write_options,[max_depth(0)]).

/*
EX 1.

1) Care din urmatoare expresii sunt atomi?:
- f                     [X]
- loves(john, mary)
- Mary
- _c1
- 'Hello'               [X]

2) Care din urmatoare expresii sunt variabile?:
- a
- A             [X]
- Paul          [X]
- 'Hello'
- a_123
- _             [X]
- _abc          [X]
*/


/* EX 2. */
female(mary).
female(sandra).
female(juliet).
female(lisa).

male(peter).
male(paul).
male(dony).
male(bob).
male(harry).

parent(bob, lisa).
parent(bob, paul).
parent(bob, mary).
parent(juliet, lisa).
parent(juliet, paul).
parent(juliet, mary).
parent(peter, harry).
parent(lisa, harry).
parent(mary, dony).
parent(mary, sandra).


father_of(Father, Child) :- parent(Father, Child), male(Father).
mother_of(Mother, Child) :- parent(Mother, Child), female(Mother).

sister_of(Sister,Person) :- parent(Parent, Sister), parent(Parent, Person), female(Sister).
brother_of(Brother,Person) :- parent(Parent, Brother), parent(Parent, Person), male(Brother).

grandfather_of(Grandfather, Child) :- father_of(Grandfather,Parent), parent(Parent,Child).
grandmother_of(Grandmother, Child) :- mother_of(Grandmother, Parent), parent(Parent, Child).

aunt_of(Aunt,Person) :- parent(Parent, Person), sister_of(Parent, Aunt).
uncle_of(Uncle,Person) :- parent(Parent, Person), brother_of(Parent, Uncle).


/* EX 3. */
not_parent(Parent, Child) :- (male(Parent); female(Parent)), (male(Child); female(Child)), \+parent(Parent,Child),  Parent \= Child.


/* EX 4. */
distance((X1, Y1), (X2, Y2), R) :- R is sqrt(abs(X2 - X1)**2 + abs(Y2 - Y1)**2).



/* TESTS
?- not_parent(bob,juliet).
?- not_parent(X,juliet).
?- not_parent(X,Y).

?- distance((0,0), (3,4), X).
?- distance((-2.5,1), (3.5,-4), X).
*/