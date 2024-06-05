%%%%%%%%%%
% CONSTS %
%%%%%%%%%%

#const minGates = 1.
#const maxGates = 10.

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

val(S, G1, N1, G2, N2, V2) :- connection(G1, N1, G2, N2), not val(S, G1, N1, G2, N2, V), signal(V), V = 1, V2 = 0, step(S).

V1 = V2 :- val(S, G1, N1, G2, N2, V1), val(S, G1, N1, G2, N2, V2), step(S).

% Not
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 1), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 0), step(S).

% And
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), step(S).

% Or
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), step(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), step(S).

% Source
val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assign(S, G1, V), step(S).

% Destination
val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assign(S, G2, V), step(S).

%%%%%%%%%%%
% OUTPUTS %
%%%%%%%%%%%


gate(x1).
gate_type(x1, source).

gate(x2).
gate_type(x2, source).

gate(y1).
gate_type(y1, destination).

%gate(y2).
%gate_type(y2, destination).

step(1; 2; 3; 4).

assign(1, x1, 0).
assign(1, x2, 0).
assign(1, y1, 0).

assign(2, x1, 1).
assign(2, x2, 0).
assign(2, y1, 1).

assign(3, x1, 0).
assign(3, x2, 1).
assign(3, y1, 1).

assign(4, x1, 1).
assign(4, x2, 1).
assign(4, y1, 0).

#minimize{N: gateCount(N)}.

%step(1; 2; 3; 4).

%assign(1, x1, 0).
%assign(1, x2, 0).
%assign(1, y1, 0).
%assign(1, y2, 0).

%assign(2, x1, 1).
%assign(2, x2, 0).
%assign(2, y1, 1).
%assign(2, y2, 0).

%assign(3, x1, 0).
%assign(3, x2, 1).
%assign(3, y1, 1).
%assign(3, y2, 0).

%assign(4, x1, 1).
%assign(4, x2, 1).
%assign(4, y1, 0).
%assign(4, y2, 1).

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).

%#show gate/1.
#show gate_type/2.
%#show connection/4.
#show con/2.
%#show val/6.
#show conval/3.
