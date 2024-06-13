% Source

type(atom).
arity(atom, input, 0).
arity(atom, output, 10).

eval(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), connective_type(G1, atom), assign(S, G1, V), valuation(S).

% Destination

type(destination).
arity(destination, input, 1).
arity(destination, output, 0).

eval(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), connective_type(G2, destination), assign(S, G2, V), valuation(S).

con(G1, G2) :- connection(G1, N1, G2, N2).
coneval(S, G1, V) :- eval(S, G1, 1, G2, N2, V).
spath(G1, G2) :- con(G1, G2).
spath(G1, G3) :- con(G1, G2), con(G2, G3).
