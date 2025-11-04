% tabling.pl - Using tabling for memoization

:- use_module(library(tabling)).

% Tabled fibonacci (much faster!)
:- table fib_tabled/2.

fib_tabled(0, 0).
fib_tabled(1, 1).
fib_tabled(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fib_tabled(N1, F1),
    fib_tabled(N2, F2),
    F is F1 + F2.

% Compare with non-tabled version
% The tabled version is exponentially faster for large N

% Example queries:
% ?- time(fib_tabled(30, X)).
