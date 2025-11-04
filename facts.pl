% facts.pl - Learning about facts and queries

% Family relationships
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

% Gender facts
male(tom).
male(bob).
male(jim).
male(pat).
female(liz).
female(ann).

% Rules derived from facts
father(X, Y) :- parent(X, Y), male(X).
mother(X, Y) :- parent(X, Y), female(X).

grandparent(X, Z) :- parent(X, Y), parent(Y, Z).

sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

% Example queries to try:
% ?- parent(tom, X).
% ?- grandparent(tom, X).
% ?- sibling(ann, X).
