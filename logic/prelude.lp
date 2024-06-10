#include "defaults.lp".

%%%%%%%%%%
% SIGNAL %
%%%%%%%%%%

signal(0; 1).

%%%%%%%%
% GATE %
%%%%%%%%

% gate(G).
% G : Gate id

% type(T).
% T : Gate type

% gate_type(G, T)
% G : gate(G)
% T : type(T)

% A gate type cannot exist when G is not a gate or T is not a gate type

:- gate_type(G, _), not gate(G).
:- gate_type(_, T), not type(T).

% arity(T, A, IO).
% T : type(T)
% A : Natural number
% IO : terminal_type(IO)

% An arity cannot exist if there is no evidence for the IO type

:- arity(_, _, IO), not terminal_type(IO).

% An arity cannot exist if the we have no evidence for the gate type

:- arity(T, _, _), not type(T).

% An arity cannot exist that is less than 0

:- arity(_, A, _), A < 0.

%%%%%%%%%%%%
% TERMINAL %
%%%%%%%%%%%%

% Static terminal types
terminal_type(tin; tout).

% terminal(G, I, IO)
% G : gate(G)
% I : gate_type(G, T), arityin(T, N), I > 0, I < N
% IO : terminal_type(IO)

% A terminal cannot exist for a gate that has no evidence
:- terminal(G, _, _), not gate(G).

terminal(G, 1..N, IO) :- gate(G), gate_type(G, T), arity(T, N, IO).

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
arity(source, 0, tin).
arity(source, 10, tout).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G1, source), assert(S, G1, V), state(S).

% Destination

type(destination).
arity(destination, 1, tin).
arity(destination, 0, tout).

val(S, G1, N1, G2, N2, V) :- connection(G1, N1, G2, N2), gate_type(G2, destination), assert(S, G2, V), state(S).

con(G1, G2) :- connection(G1, N1, G2, N2).
conval(S, G1, V) :- val(S, G1, 1, G2, N2, V).
spath(G1, G3) :- con(G1, G2), con(G2, G3).
