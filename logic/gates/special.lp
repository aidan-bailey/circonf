% Source

type(source).
arity(source, 0, tin).
arity(source, 10, tout).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assert(S, G1, V), state(S).

% Destination

type(destination).
arity(destination, 1, tin).
arity(destination, 0, tout).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assert(S, G2, V), state(S).

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).
spath(G1, G3) :- con(G1, G2), con(G2, G3).
