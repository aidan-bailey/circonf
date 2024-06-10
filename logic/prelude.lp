#include "defaults.lp".

%%%%%%%%%%
% SIGNAL %
%%%%%%%%%%

signal(0; 1).

%%%%%%%%
% GATE %
%%%%%%%%

% gate_type(G, T)
% G : gate(G)
% T : type(T)

% arityout(T, A).
% T : type(T)
% A : Number

%%%%%%%%%%%%
% TERMINAL %
%%%%%%%%%%%%

% Static terminal types
terminal_type(tin; tout).

% terminal(G, I, IO)
% G : gate(G)
% I : gate_type(G, T), arityin(T, N), I > 0, I < N
% IO : terminal_type(IO)

terminal(G, 1..N, tin) :- gate(G), gate_type(G, T), arityin(T, N).
terminal(G, 1..N, tout) :- gate(G), gate_type(G, T), arityout(T, N).

%%%%%%%%%%%%%%
% CONNECTION %
%%%%%%%%%%%%%%

% connection(Gout, Iout, Gin, Iin)
% Gout : gate(Gout)
% Iout :
% Gin : gate(Gin)
% Iin :

% Connection

% Valuation

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

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).
spath(G1, G3) :- con(G1, G2), con(G2, G3).
