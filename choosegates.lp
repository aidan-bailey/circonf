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
arityin(source, 1).
arityout(source, 0).

terminal(G, 1..N, tin) :- gate(G), gate_type(G, T), arityin(T, N).
terminal(G, 1..N, tout) :- gate(G), gate_type(G, T), arityout(T, N).

%%%%%%%%%%%%%%%%%%
% GENERATE GATES %
%%%%%%%%%%%%%%%%%%

{gateCount(N): N = minGates..maxGates} = 1.

gate(1..N) :- gateCount(N).

{gate_type(I, T): type(T), T != source, T != destination} = 1 :- gate(I).

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

%%%%%%%%%%%
% OUTPUTS %
%%%%%%%%%%%

gate(x).
gate_type(0, source).

gate(y).
gate_type(0, destination).

%#show terminal/3.
%#show gateCount/1.
#show gate/1.
#show gate_type/2.
%#show terminal/3.
%#show numTerminalOuts/1.
#show connect/4.
