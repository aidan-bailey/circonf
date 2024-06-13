% Source

type(atom).
arity(atom, input, 0).
arity(atom, output, 10).

eval(S, F1, N1, F2, N2, V) :- connection(F1, N1, F2, N2), connective_type(F1, atom), assign(S, F1, V), valuation(S).

% Destination

type(destination).
arity(destination, input, 1).
arity(destination, output, 0).

eval(S, F1, N1, F2, N2, V) :- connection(F1, N1, F2, N2), connective_type(F2, destination), assign(S, F2, V), valuation(S).

con(F1, F2) :- connection(F1, N1, F2, N2).
coneval(S, F1, V) :- eval(S, F1, 1, F2, N2, V).
spath(F1, F2) :- con(F1, F2).
spath(F1, F3) :- con(F1, F2), con(F2, F3).
