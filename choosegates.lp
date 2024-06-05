%%%%%%%%%%
% CONSTS %
%%%%%%%%%%

#const minGates = 1.
#const maxGates = 10.

%%%%%%%%%%%%%%%
% DEFINITIONS %
%%%%%%%%%%%%%%%

terminal_type(tin, tout).

terminal(G, 1..N, tin) :- gate(G), gate_type(G, T), arityin(T, N).
terminal(G, 1..N, tout) :- gate(G), gate_type(G, T), arityout(T, N).

%%%%%%%%%
% GATES %
%%%%%%%%%

signal(0; 1).

val(S, G1, N1, G2, N2, V2) :- connection(G1, N1, G2, N2), not val(S, G1, N1, G2, N2, V), signal(V), V = 1, V2 = 0, step(S).

V1 = V2 :- val(S, G1, N1, G2, N2, V1), val(S, G1, N1, G2, N2, V2), step(S).

% Source

type(source).
arityin(source, 0).
arityout(source, 10).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assert(S, G1, V), step(S).

% Destination

type(destination).
arityin(destination, 1).
arityout(destination, 0).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assert(S, G2, V), step(S).

% Not

type(not_g).
arityin(not_g, 1).
arityout(not_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 1), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 0), step(S).

% And

type(and_g).
arityin(and_g, 2).
arityout(and_g, 1).

val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), step(S).

% Or

type(or_g).
arityin(or_g, 2).
arityout(or_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), step(S).

% Xor

type(xor_g).
arityin(xor_g, 2).
arityout(xor_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, xor_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), step(S).

%%%%%%%%%%%%%%%%%%
% GENERATE GATES %
%%%%%%%%%%%%%%%%%%

{gateCount(N): N = minGates..maxGates} = 1.

gate(1..N) :- gateCount(N).

{gate_type(I, T): type(T), T != source, T != destination} = 1 :- I = 1..N, gate(I), gateCount(N).

numTerminalIns(N) :- #count{G, I: terminal(G, I, tin)} = N.

numTerminalOuts(N) :- #count{G, I: terminal(G, I, tout)} = N.

%%%%%%%%%%%%%%%%%%%%%%
% CREATE CONNECTIONS %
%%%%%%%%%%%%%%%%%%%%%%

0{connection(Gout, Nout, Gin, Nin): terminal(Gin, Nin, tin)}1 :- terminal(Gout, Nout, tout), gate_type(Gout, T).

:- connection(G, Nout, G, Nin).
N1 = N2 :- connection(G, N1, G2, N), connection(G, N2, G2, N).
G1 = G2 :- connection(G1, N, G2, N), connection(G2, N, G2, N).
:- terminal(G, N, tin), not connection(_, _, G, N).
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

gate(y3).
gate_type(y3, destination).

step(1; 2; 3; 4; 5; 6; 7).

assert(1, x1, 0).
assert(1, x2, 0).
assert(1, x3, 0).
assert(1, y1, 0).
assert(1, y2, 0).
assert(1, y3, 0).

assert(2, x1, 1).
assert(2, x2, 0).
assert(2, x3, 0).
assert(2, y1, 1).
assert(2, y2, 0).
assert(2, y3, 0).

assert(3, x1, 0).
assert(3, x2, 1).
assert(3, x3, 0).
assert(3, y1, 1).
assert(3, y2, 0).
assert(3, y3, 0).

assert(4, x1, 0).
assert(4, x2, 0).
assert(4, x3, 1).
assert(4, y1, 1).
assert(4, y2, 0).
assert(4, y3, 0).

assert(5, x1, 1).
assert(5, x2, 1).
assert(5, x3, 0).
assert(5, y1, 0).
assert(5, y2, 1).
assert(5, y3, 0).

assert(6, x1, 0).
assert(6, x2, 1).
assert(6, x3, 1).
assert(6, y1, 0).
assert(6, y2, 1).
assert(6, y3, 0).

assert(7, x1, 1).
assert(7, x2, 1).
assert(7, x3, 1).
assert(7, y1, 0).
assert(7, y2, 0).
assert(7, y3, 1).

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

#minimize{N: gateCount(N)}.

#show gate_type/2.
#show con/2.
