:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- include('words.pl').



% EX 1.
% 1)
la_dreapta(X, Y) :-
    Y =:= X - 1.

% 2)
la_stanga(X, Y) :-
    Y =:= X + 1.

% 3)
/*langa(X, Y) :-
    D is abs(X - Y),
    D =:= 1.*/

langa(X, Y) :-
    la_dreapta(X, Y),
    !;
    la_stanga(X, Y).

% 4)
% casa(Numar,Nationalitate,Culoare,AnimalCompanie,Bautura,Tigari)
solutie(Strada, PosesorZebra) :-
    % 1. Sunt cinci case.
    Strada = [
        casa(1,_,_,_,_,_),
        casa(2,_,_,_,_,_),
        casa(3,_,_,_,_,_),
        casa(4,_,_,_,_,_),
        casa(5,_,_,_,_,_)],
    % 2. Englezul locuieste in casa rosie.
    member(casa(_,englez,rosie,_,_,_), Strada),
    % 3. Spaniolul are un caine.
    member(casa(_,spaniol,_,caine,_,_), Strada),
    % 4. In casa verde se bea cafea.
    member(casa(_,_,verde,_,"cafea",_), Strada),
    % 5. Ucraineanul bea ceai.
    member(casa(_,ucrainean,_,_,"ceai",_), Strada),
    % 6. Casa verde este imediat in dreapta casei bej.
    member(casa(X1,_,verde,_,_,_), Strada),
    member(casa(Y1,_,bej,_,_,_), Strada),
    la_dreapta(X1, Y1),
    % 7. Fumatorul de ”Old Gold” are melci.
    member(casa(_,_,_,melci,_,"Old Gold"), Strada),
    % 8. In casa galbena se fumeaza ”Kools”.
    member(casa(_,_,galbena,_,_,"Kools"), Strada),
    % 9. In casa din mjloc se bea lapte.
    length(Strada, L),
    Q is div(L, 2) + 1,
    member(casa(Q,_,_,_,"lapte",_), Strada),
    % 10. Norvegianul locuieste in prima casa.
    member(casa(1,norvegian,_,_,_,_), Strada),
    % 11. Fumatorul de ”Chesterfields” locuieste langa cel care are o vulpe.
    member(casa(X2,_,_,_,_,"Chesterfields"), Strada),
    member(casa(Y2,_,_,vulpe,_,_), Strada),
    langa(X2, Y2),
    % 12. ”Kools” sunt fumate in casa de langa cea in care se tine calul.
    member(casa(X3,_,_,_,_,"Kools"), Strada),
    member(casa(Y3,_,_,cal,_,_), Strada),
    langa(X3, Y3),
    % 13. Fumatorul de ”Lucky Strike” bea suc de portocale.
    member(casa(_,_,_,_,"suc de portocale","Lucky Strike"), Strada),
    % 14. Japonezul fumeaza ”Parliaments”.
    member(casa(_,japonez,_,_,_,"Parliaments"), Strada),
    % 15. Norvegianul locuieste langa casa albastra.
    member(casa(X4,norvegian,_,_,_,_), Strada),
    member(casa(Y4,_,albastra,_,_,_), Strada),
    langa(X4, Y4),
    % FINAL.
    member(casa(_,PosesorZebra,_,zebra,_,_), Strada),
    !.



% EX 2.
% 1)
word_letters(W, CharList) :- 
    atom_chars(W, CharList).

cover([], _).
cover([H | T], L) :-
    select(H, L, L1),
    cover(T, L1).

solution(CharList, Word, Len) :-
    word(Word),
    word_letters(Word, W),
    cover(W, CharList),
    length(W, Len).

% 2)
topcounter(L, Word, Len) :-
    solution(L, Word, Len),
    !;
    Len1 is Len - 1,
    topcounter(L, Word, Len1).

topsolution(L, Word) :-
    length(L, Len),
    topcounter(L, Word, Len).