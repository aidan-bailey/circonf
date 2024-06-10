#include "defaults.lp".

%%%%%%%%%%%
% STATICS %
%%%%%%%%%%%

% True/False signals
signal(0; 1).

% Static terminal types
io(input; output).

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
% IO : io(IO)
% A : Natural number

% An arity cannot exist if the we have no evidence for the gate type

:- arity(T, _, _), not type(T).

% An arity cannot exist if there is no evidence for the IO type

:- arity(_, IO, _), not io(IO).

% An arity cannot exist that is less than 0

:- arity(_, _, A), A < 0.

%%%%%%%%%%%%%%%
% CONSTRUCTED %
%%%%%%%%%%%%%%%

% terminal(G, I, IO)
% G : gate(G)
% I : gate_type(G, T), arityin(T, N), I > 0, I < N
% IO : io(IO)

% A terminal cannot exist for a gate that has no evidence
:- terminal(G, _, _), not gate(G).

% A terminal cannot exist if it is not input or output
:- terminal(_, _, IO), not io(IO).

% A terminal is constructed for each gates input and output arity
terminal(G, 1..N, IO) :- gate(G), gate_type(G, T), arity(T, IO, N).

% Valuation

% valuation(N)
% N : Natural number

valuation(1..2**N) :- #count{G: gate_type(G, source)} = N.

% assign(N, G, S)
% N : valuation(N)
% G : gate(G)
% S : signal(S)

:- assign(N, _, _), not valuation(N).
:- assign(_, G, _), not gate(G).
:- assign(_, _, S), not signal(S).

S1 = S2 :- assign(N, G, S1), assign(N, G, S2).

% Eval

% eval(S, G1, N1, G2, N2, V2)
% S
% G1
% N1
% G2
% N2
% V2

% There must be evidence of a valuation for there to be an evaluation
:- eval(N, _, _, _, _, _), not valuation(N).

S1 = S2 :- eval(V, G1, N1, G2, N2, S1), eval(V, G1, N1, G2, N2, S2), valuation(V).

eval(V, G1, N1, G2, N2, S2) :-
    connection(G1, N1, G2, N2),
    not eval(V, G1, N1, G2, N2, S),
    signal(S), S = 1, S2 = 0,
    valuation(V).

%:- eval(_, G1, N1, G2, N2, _), not connection(G1, N1, G2, G2).

%%%%%%%%%%
% HYBRID %
%%%%%%%%%%

% connection(Gout, Iout, Gin, Iin)
% Gout : gate(Gout)
% Iout :
% Gin : gate(Gin)
% Iin :

% There must be explicit evidence for each terminal
:- connection(G, I, _, _), not terminal(G, I, output).
:- connection(_, _, G, I), not terminal(G, I, input).

% There cannot be multiple connections to the same input pin
G1 = G2 :- connection(G1, _, G, N), connection(G2, _, G, N).
I1 = I2 :- connection(G, I1, G, N), connection(G, I2, G, N).

#include "gates/special.lp".
