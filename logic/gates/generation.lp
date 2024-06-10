{gateCount(N): N = minGates..maxGates} = 1.

gate(1..N) :- gateCount(N).

{gate_type(G, T): type(T)} = 1 :- gate(G), not gate_type(G, destination), not gate_type(G, source).

%%%%%%%%%%%%%%%%%%%%%%
% CREATE CONNECTIONS %
%%%%%%%%%%%%%%%%%%%%%%

% Choose to connect an output terminal of a gate
0{connection(Gout, Nout, Gin, Nin): terminal(Gin, Nin, tin)}1 :- terminal(Gout, Nout, tout), gate_type(Gout, T).

% Every input needs a connection
:- terminal(G, N, tin), not connection(_, _, G, N).

% Multiple gates output terminals cannot be connected to the same input terminal
G1 = G2 :- connection(G1, N, G, N), connection(G2, N, G, N).
N1 = N2 :- connection(G, N1, G, N), connection(G, N2, G, N).

% A gate must have at least one output connection if its arityout is greater than 0
N = 0 :- gate(G), gate_type(G, T), arity(T, N, tout), not connection(G, _, _, _).
