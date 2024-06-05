%%%%%%%%%%
% CONSTS %
%%%%%%%%%%

#const minGates = 1.
#const maxGates = 1.

%%%%%%%%%%%%%%%
% DEFINITIONS %
%%%%%%%%%%%%%%%

terminal_type(tin, tout).

type(not_g).
arityin(not_g, 1).
arityout(not_g, 1).

type(and_g;or_g).
arityin((and_g; or_g), 2).
arityout((and_g; or_g), 1).

type(source).
arityin(source, 0).
arityout(source, 1).

type(destination).
arityin(destination, 1).
arityout(destination, 0).

terminal(G, 1..N, tin) :- gate(G), gate_type(G, T), arityin(T, N).
terminal(G, 1..N, tout) :- gate(G), gate_type(G, T), arityout(T, N).

%%%%%%%%%%%%%%%%%%
% GENERATE GATES %
%%%%%%%%%%%%%%%%%%

{gateCount(N): N = minGates..maxGates} = 1.

gate(1..N) :- gateCount(N).

{gate_type(I, T): type(T), T != source, T != destination} = 1 :- I = 1..N, gate(I), gateCount(N).

numTerminalIns(N) :- #count{G, I: terminal(G, I, tin)} = N.
numTerminalOuts(N) :- #count{G, I: terminal(G, I, tout)} = N.
Ni = No :- numTerminalIns(Ni), numTerminalOuts(No).

%%%%%%%%%%%%%%%%%%%%%%
% CREATE CONNECTIONS %
%%%%%%%%%%%%%%%%%%%%%%

{connection(Gout, Nout, Gin, Nin): terminal(Gin, Nin, tin)} = 1 :- terminal(Gout, Nout, tout).

:- connection(G, Nout, G, Nin).
N1 = N2 :- connection(G, N1, G2, N), connection(G, N2, G2, N).
G1 = G2 :- connection(G1, N, G2, N), connection(G2, N, G2, N).
:- terminal(G, N, tin), not connection(_, _, G, N).
:- terminal(G, N, tout), not connection(G, N, _, _).

%%%%%%%%%%%%%%
% INPUT VALS %
%%%%%%%%%%%%%%

signal(0; 1).

val(G1, N1, G2, N2, V2) :- connection(G1, N1, G2, N2), not val(G1, N1, G2, N2, V), signal(V), V = 1, V2 = 0.

V1 = V2 :- val(G1, N1, G2, N2, V1), val(G1, N1, G2, N2, V2).

% Not
val(G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(_, _, G1, N1, 0).

% And
val(G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(_, _, G1, 1, 1), val(_, _, G1, 2, 1).
val(G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(_, _, G1, 1, 1), val(_, _, G1, 2, 0).
val(G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(_, _, G1, 1, 0), val(_, _, G1, 2, 1).
val(G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(_, _, G1, 1, 0), val(_, _, G1, 2, 0).

% Or
val(G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(_, _, G1, 1, 0), val(_, _, G1, 2, 0).
val(G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(_, _, G1, 1, 0), val(_, _, G1, 2, 1).
val(G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(_, _, G1, 1, 1), val(_, _, G1, 2, 0).
val(G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(_, _, G1, 1, 1), val(_, _, G1, 2, 1).

% Source
val(G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assign(G1, V).

% Destination
val(G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assign(G2, V).

%%%%%%%%%%%
% OUTPUTS %
%%%%%%%%%%%

gate(x1).
gate_type(x1, source).
assign(x1, 0).

gate(x2).
gate_type(x2, source).
assign(x2, 0).

gate(y).
gate_type(y, destination).
assign(y, 1).

%#show terminal/3.
%#show gateCount/1.
#show gate/1.
#show gate_type/2.
%#show terminal/3.
%#show numTerminalOuts/1.
%#show connect/4.
%#show numWires/1.
%#show arityin/2.
%#show connection/4.

#show val/5.
