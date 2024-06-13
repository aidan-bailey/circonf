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

% connective(G).
% G : Gate id

% type(T).
% T : Gate type

% connective_type(G, T)
% G : connective(G)
% T : type(T)

% A connective type cannot exist when G is not a connective or T is not a connective type

:- connective_type(G, _), not connective(G).
:- connective_type(_, T), not type(T).

% arity(T, A, IO).
% T : type(T)
% IO : io(IO)
% A : Natural number

% An arity cannot exist if the we have no evidence for the connective type

:- arity(T, _, _), not type(T).

% An arity cannot exist if there is no evidence for the IO type

:- arity(_, IO, _), not io(IO).

% An arity cannot exist that is less than 0

:- arity(_, _, A), A < 0.

%%%%%%%%%%%%%%%
% CONSTRUCTED %
%%%%%%%%%%%%%%%

% terminal(G, I, IO)
% G : connective(G)
% I : connective_type(G, T), arityin(T, N), I > 0, I < N
% IO : io(IO)

% A terminal cannot exist for a connective that has no evidence
:- terminal(G, _, _), not connective(G).

% A terminal cannot exist if it is not input or output
:- terminal(_, _, IO), not io(IO).

% A terminal is constructed for each connectives input and output arity
terminal(G, 1..N, IO) :- connective(G), connective_type(G, T), arity(T, IO, N).

% Valuation

% valuation(N)
% N : Natural number

atomCount(N) :- #count{G: connective_type(G, atom)} = N.

valuation(1..2**N) :- atomCount(N).

valuationCount(N) :- #count{V: valuation(V)} = N.

% assign(N, G, S)
% N : valuation(N)
% G : connective(G)
% S : signal(S)

:- not assign(N, _, _), valuation(N).
:- assign(N, _, _), not valuation(N).
:- assign(_, G, _), not connective(G).
:- assign(_, _, S), not signal(S).

S1 = S2 :- assign(N, G, S1), assign(N, G, S2).

% Eval

% eval(S, F1, N1, F2, N2, V2)
% S
% F1
% N1
% F2
% N2
% V2

% There must be evidence of a valuation for there to be an evaluation
:- eval(N, _, _, _, _, _), not valuation(N).

S1 = S2 :- eval(V, F1, N1, F2, N2, S1), eval(V, F1, N1, F2, N2, S2), valuation(V).

eval(V, F1, N1, F2, N2, 0) :- connection(F1, N1, F2, N2),
    not eval(V, F1, N1, F2, N2, 1),
    valuation(V).

%%%%%%%%%%
% HYBRID %
%%%%%%%%%%

% connection(Gout, Iout, Gin, Iin)
% Gout : connective(Gout)
% Iout :
% Gin : connective(Gin)
% Iin :

% There must be explicit evidence for each terminal
:- connection(G, I, _, _), not terminal(G, I, output).
:- connection(_, _, G, I), not terminal(G, I, input).

% There cannot be multiple connections to the same input pin
F1 = F2 :- connection(F1, _, G, N), connection(F2, _, G, N).
I1 = I2 :- connection(G, I1, G, N), connection(G, I2, G, N).

#include "connectives/atom.lp".

val(V, G, S) :- valuation(V), connective_type(G, atom), assign(V, G, S).
val(V, G, S) :- eval(V, _, _, G, _, S), valuation(V), connective_type(G, destination).

formula(Gdest, G) :- spath(G, Gdest), connective_type(Gdest, destination).
