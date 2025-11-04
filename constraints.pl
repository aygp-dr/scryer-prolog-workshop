% constraints.pl - Introduction to constraints

:- use_module(library(clpz)).

% Simple arithmetic constraints
demo_clpz :-
    X #> 0,
    X #< 10,
    X #= Y + 3,
    Y #= 5,
    write('X = '), write(X), nl.

% N-Queens problem (4x4 board)
n_queens(N, Qs) :-
    length(Qs, N),
    Qs ins 1..N,
    safe_queens(Qs).

safe_queens([]).
safe_queens([Q|Qs]) :-
    safe_queens(Qs, Q, 1),
    safe_queens(Qs).

safe_queens([], _, _).
safe_queens([Q|Qs], Q0, D0) :-
    Q0 #\= Q,
    abs(Q0 - Q) #\= D0,
    D1 is D0 + 1,
    safe_queens(Qs, Q0, D1).

% Example queries:
% ?- demo_clpz.
% ?- n_queens(4, Qs), label(Qs).
