%%%%%%%%%%
% CONSTS %
%%%%%%%%%%

% Minimum number of logic gates
#const minGates = 1.

% Maximum number of logic gates
#const maxGates = 10.

%%%%%%%%%%%%%%%
% DEFINITIONS %
%%%%%%%%%%%%%%%

% Terminal types
terminal_type(tin, tout).

% Initialise terminals for gates
terminal(G, 1..N, tin) :- gate(G), gate_type(G, T), arityin(T, N).
terminal(G, 1..N, tout) :- gate(G), gate_type(G, T), arityout(T, N).

%%%%%%%%%
% GATES %
%%%%%%%%%

signal(0; 1).

val(S, G1, N1, G2, N2, V2) :- connection(G1, N1, G2, N2), not val(S, G1, N1, G2, N2, V), signal(V), V = 1, V2 = 0, state(S).

V1 = V2 :- val(S, G1, N1, G2, N2, V1), val(S, G1, N1, G2, N2, V2), state(S).

% Source

type(source).
arityin(source, 0).
arityout(source, 10).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assert(S, G1, V), state(S).

% Destination

type(destination).
arityin(destination, 1).
arityout(destination, 0).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assert(S, G2, V), state(S).

% Not

type(not_g).
arityin(not_g, 1).
arityout(not_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 1), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 0), state(S).

% And

type(and_g).
arityin(and_g, 2).
arityout(and_g, 1).

val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), state(S).

% Or

type(or_g).
arityin(or_g, 2).
arityout(or_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), state(S).

% Xor

type(xor_g).
arityin(xor_g, 2).
arityout(xor_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), state(S).

%%%%%%%%%%%%%%%%%%
% GENERATE GATES %
%%%%%%%%%%%%%%%%%%

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
N = 0 :- gate(G), gate_type(G, T), arityout(T, N), not connection(G, _, _, _).

%%%%%%%%%%%
% OUTPUTS %
%%%%%%%%%%%

gate(x1).
gate_type(x1, source).

gate(x2).
gate_type(x2, source).

gate(x3).
gate_type(x3, source).

gate(y1).
gate_type(y1, destination).

gate(y2).
gate_type(y2, destination).

state(1; 2; 3; 4; 5; 6; 7).

assert(1, x1, 0).
assert(1, x2, 0).
assert(1, x3, 0).
assert(1, y1, 0).
assert(1, y2, 0).

assert(2, x1, 1).
assert(2, x2, 0).
assert(2, x3, 0).
assert(2, y1, 1).
assert(2, y2, 0).

assert(3, x1, 0).
assert(3, x2, 1).
assert(3, x3, 0).
assert(3, y1, 1).
assert(3, y2, 0).

assert(4, x1, 0).
assert(4, x2, 0).
assert(4, x3, 1).
assert(4, y1, 1).
assert(4, y2, 0).

assert(5, x1, 1).
assert(5, x2, 1).
assert(5, x3, 0).
assert(5, y1, 0).
assert(5, y2, 1).

assert(6, x1, 0).
assert(6, x2, 1).
assert(6, x3, 1).
assert(6, y1, 0).
assert(6, y2, 1).

assert(7, x1, 1).
assert(7, x2, 1).
assert(7, x3, 1).
assert(7, y1, 1).
assert(7, y2, 1).

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

#minimize{N: gateCount(N)}.

#show gate_type/2.
#show con/2.
