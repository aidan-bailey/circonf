#include "defaults.lp".

%%%%%%%%%%%
% STATICS %
%%%%%%%%%%%

% True/False signals
signal(0; 1).

% Static terminal types
terminal_type(tin; tout).

%%%%%%%%%%%%%%%%%%
% SPECIFICATIONS %
%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%
% CONSTRUCTED %
%%%%%%%%%%%%%%%

% terminal(G, I, IO)
% G : gate(G)
% I : gate_type(G, T), arityin(T, N), I > 0, I < N
% IO : terminal_type(IO)

% A terminal cannot exist for a gate that has no evidence
:- terminal(G, _, _), not gate(G).

% A terminal cannot exist if it is not input or output
:- terminal(_, _, IO), not terminal_type(IO).

% A terminal is constructed for each gates input and output arity
terminal(G, 1..N, IO) :- gate(G), gate_type(G, T), arity(T, N, IO).

% Valuation

val(S, G1, N1, G2, N2, V2) :- connection(G1, N1, G2, N2), not val(S, G1, N1, G2, N2, V), signal(V), V = 1, V2 = 0, state(S).

V1 = V2 :- val(S, G1, N1, G2, N2, V1), val(S, G1, N1, G2, N2, V2), state(S).

%%%%%%%%%%
% HYBRID %
%%%%%%%%%%

% connection(Gout, Iout, Gin, Iin)
% Gout : gate(Gout)
% Iout :
% Gin : gate(Gin)
% Iin :

% There must be explicit evidence for each terminal
:- connection(G, I, _, _), not terminal(G, I, tout).
:- connection(_, _, G, I), not terminal(G, I, tin).

% There cannot be multiple connections to the same input pin
G1 = G2 :- connection(G1, _, G, N), connection(G2, _, G, N).
I1 = I2 :- connection(G, I1, G, N), connection(G, I2, G, N).

#include "gates/special.lp".
