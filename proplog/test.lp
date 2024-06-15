#include "types.lp".

atom(a; b).

% atom should have exactly 1 model
:- models(a, N), N != 1.

% a is a model of a
:- not model(a, 1, a).

%%%%%%%%%%%%%%%
% IMPLICATION %
%%%%%%%%%%%%%%%

connective(impl, limpl).
connection(a, impl, 1).
connection(b, impl, 2).

% impl: { {-a}, {b} }
:- models(impl, N), N != 2.
:- literals(impl, 1, N), N != 1.
:- literals(impl, 2, N), N != 1.
:- not model(impl, 1, -a).
:- not model(impl, 2, b).

%%%%%%%%%%%%%%%
% DISJUNCTION %
%%%%%%%%%%%%%%%

connective(disj, lor).
connection(a, disj, 1).
connection(b, disj, 2).

% disj: { {a}, {b} }
:- models(disj, N), N != 2.
:- literals(disj, 1, N), N != 1.
:- literals(disj, 2, N), N != 1.
:- not model(disj, 1, a).
:- not model(disj, 2, b).

%%%%%%%%%%%%%%%
% CONJUNCTION %
%%%%%%%%%%%%%%%

connective(conj, land).
connection(a, conj, 1).
connection(b, conj, 2).

% conj: { {a, b} }
:- models(conj, N), N != 1.
:- literals(conj, 1, N), N != 2.
:- not model(conj, 1, a).
:- not model(conj, 1, b).

%%%%%%%%%%%%
% NEGATION %
%%%%%%%%%%%%

connective(neg, lnot).
connection(a, neg, 1).

% neg: { {-a} }
:- models(neg, N), N != 1.
:- literals(neg, 1, N), N != 1.
:- not model(neg, 1, -a).

#show.
