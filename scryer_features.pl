% scryer_features.pl - Exploring Scryer Prolog features

:- use_module(library(lists)).
:- use_module(library(format)).
:- use_module(library(dcgs)).

% Using format for output
demo_format :-
    format("Hello from format!~n", []),
    format("Number: ~d, Float: ~f~n", [42, 3.14159]),
    format("String: ~s~n", ["Scryer Prolog"]).

% DCG (Definite Clause Grammar) example
sentence --> noun_phrase, verb_phrase.
noun_phrase --> determiner, noun.
verb_phrase --> verb, noun_phrase.

determiner --> [the].
determiner --> [a].
noun --> [cat].
noun --> [dog].
verb --> [chases].
verb --> [sees].

% Using library(lists)
demo_lists :-
    List = [1, 2, 3, 4, 5],
    length(List, Len),
    format("List length: ~d~n", [Len]),
    sum_list(List, Sum),
    format("List sum: ~d~n", [Sum]),
    reverse(List, Rev),
    format("Reversed: ~w~n", [Rev]).

% Example queries:
% ?- demo_format.
% ?- phrase(sentence, [the, cat, chases, a, dog]).
% ?- demo_lists.
