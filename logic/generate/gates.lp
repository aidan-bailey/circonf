{gateCount(N): N = minGates..maxGates} = 1.

gate(1..N) :- gateCount(N).

{gate_type(G, T): type(T), T != source, T != destination} = 1 :- gate(G), not gate_type(G, destination), not gate_type(G, source).

% Choose to connect an output terminal of a gate
0{connection(Gout, Nout, Gin, Nin): terminal(Gin, Nin, input)}1 :- terminal(Gout, Nout, output), gate_type(Gout, T).

% Every input needs a connection
:- terminal(G, N, input), not connection(_, _, G, N).

% A gate must have at least one output connection if its arityout is greater than 0
N = 0 :- gate(G), gate_type(G, T), arity(T, output, N), not connection(G, _, _, _).

:- connection(G1, _, G2, _), G1 = G2.
