% Source

type(source).
arity(source, 0, input).
arity(source, 10, output).

eval(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assign(S, G1, V), valuation(S).

% Destination

type(destination).
arity(destination, 1, input).
arity(destination, 0, output).

eval(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assign(S, G2, V), valuation(S).

con(G1, G2) :- connection(G1, N1, G2, N2).
coneval(S, G1, V) :- eval(S, G1, 1, G2, N2, V).
spath(G1, G3) :- con(G1, G2), con(G2, G3).
