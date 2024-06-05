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
numWires(Ni) :- numTerminalIns(Ni).

%%%%%%%%%%%%%%%%%%%%%%
% CREATE CONNECTIONS %
%%%%%%%%%%%%%%%%%%%%%%

wtype(win, wout).

wire(1..N) :- numWires(N).

{connect(G, N, tin, W): terminal(G, N, tin)} = 1 :- wire(W).
{connect(G, N, tout, W): terminal(G, N, tout)} = 1 :- wire(W).

W1 = W2 :- connect(G, N, T, W1), connect(G, N, T, W2).
N1 = N2 :- connect(G, N1, T, W), connect(G, N2, T, W).
W1 != W2 :- connect(G, _, tin, W1), connect(G, _, tout, W2).

%%%%%%%%%%%%%%
% INPUT VALS %
%%%%%%%%%%%%%%

:- val(W, 1), val(W, 0).

val(W, 0) :- wire(W), not val(W, 1).

%val(W, 1) :- gate(G), gate_type(G, and_g), wire(W),
%             arityin(and_g, A), #sum{V, wire(Win): val(Win, V), connect(G, 1..A, tin, Win)} = A.

%val(W, 1) :- gate(G), gate_type(G, or_g), wire(W),
%             arityin(or_g, A), #sum{V, wire(Win): val(Win, V), connect(G, 1..A, tin, Win)} > 0.

%val(W, 1) :- gate(G), gate_type(G, not_g), wire(W), connect(G, 1, tin, Win), val(Win, 0).

%val(W, V) :- gate(G), gate_type(G, source), wire(W), arityout(source, A), connect(G, 1, tout, W), assign(G, V).

%val(W, V) :- gate(G), gate_type(G, destination), wire(W), arityin(destination, A), connect(G, 1, tin, W), assign(G, V).


%%%%%%%%%%%
% OUTPUTS %
%%%%%%%%%%%

gate(x).
gate_type(x, source).
assign(x, 1).

gate(y).
gate_type(y, destination).
assign(y, 0).

%#show terminal/3.
%#show gateCount/1.
%#show gate/1.
%#show gate_type/2.
%#show terminal/3.
%#show numTerminalOuts/1.
%#show connect/4.
%#show numWires/1.
%#show arityin/2.
%#show arityout/2.

#show val/2.
