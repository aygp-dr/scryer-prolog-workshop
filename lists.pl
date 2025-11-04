% lists.pl - Working with lists in Prolog

% List membership
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

% List length
my_length([], 0).
my_length([_|T], N) :- my_length(T, N1), N is N1 + 1.

% List append
my_append([], L, L).
my_append([H|T1], L2, [H|T3]) :- my_append(T1, L2, T3).

% List reversal
my_reverse([], []).
my_reverse([H|T], R) :- my_reverse(T, RT), my_append(RT, [H], R).

% Sum of list
sum_list([], 0).
sum_list([H|T], Sum) :- sum_list(T, Rest), Sum is H + Rest.

% Example queries:
% ?- my_member(3, [1,2,3,4]).
% ?- my_length([a,b,c], N).
% ?- my_append([1,2], [3,4], X).
% ?- my_reverse([1,2,3], X).
% ?- sum_list([1,2,3,4,5], X).
