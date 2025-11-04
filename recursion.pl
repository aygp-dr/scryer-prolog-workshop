% recursion.pl - Recursive predicates

% Factorial
factorial(0, 1).
factorial(N, F) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, F1),
    F is N * F1.

% Fibonacci
fibonacci(0, 0).
fibonacci(1, 1).
fibonacci(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    F is F1 + F2.

% Range generation
range(N, N, [N]).
range(M, N, [M|T]) :-
    M < N,
    M1 is M + 1,
    range(M1, N, T).

% Example queries:
% ?- factorial(5, X).
% ?- fibonacci(10, X).
% ?- range(1, 10, X).
