% hello.pl - Your first Scryer Prolog program

% Facts: Basic statements about the world
greeting('Hello, World!').
greeting('Welcome to Scryer Prolog!').
greeting('Prolog is awesome!').

% Rule: Define relationships
say_hello :-
    greeting(Message),
    write(Message), nl.

% Predicate to greet by name
greet(Name) :-
    write('Hello, '), write(Name), write('!'), nl.

% Main entry point
main :-
    write('=== Scryer Prolog Workshop ==='), nl,
    say_hello,
    write('Available greetings:'), nl,
    forall(greeting(G), (write('  - '), write(G), nl)),
    halt.
