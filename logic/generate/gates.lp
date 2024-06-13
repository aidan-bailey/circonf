{connectiveCount(N): N = minGates..maxGates} = 1.

connective(1..N) :- connectiveCount(N).

{connective_type(G, T): type(T), T != atom, T != destination} = 1 :- connective(G), not connective_type(G, destination), not connective_type(G, atom).

% Choose to connect an output terminal of a connective
0{connection(Gout, Nout, Gin, Nin): terminal(Gin, Nin, input)}1 :- terminal(Gout, Nout, output), connective_type(Gout, T).

% Every input needs a connection
:- terminal(G, N, input), not connection(_, _, G, N).

% A connective must have at least one output connection if its arityout is greater than 0
N = 0 :- connective(G), connective_type(G, T), arity(T, output, N), not connection(G, _, _, _).

:- connection(F1, _, F2, _), F1 = F2.
