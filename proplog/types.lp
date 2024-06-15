#include "and.lp".
#include "or.lp".
#include "not.lp".
#include "implies.lp".

%%%%%%%%%%%
% FORMULA %
%%%%%%%%%%%

formula_type(atom; const; conn).

% a formula has to have a defined type
:- formula(_, T), not formula_type(T).

% a formula can only have one type
:- formula(F, T1), formula(F, T2), T1 != T2.

%%%%%%%%
% ATOM %
%%%%%%%%

formula(F, atom) :- atom(F).

%%%%%%%%%%%%
% CONSTANT %
%%%%%%%%%%%%

const_type(verum; falsum).

%%%%%%%%%%%%%%
% CONNECTIVE %
%%%%%%%%%%%%%%

% a connective has to have a defined type
:- connective(F, T), not connective_type(T).

% a connective can only have one type
:- connective(F, T1), connective(F, T2), T1 != T2.

% a connective has to have an arity
formula(F, conn) :- connective(F, T), connective_type(T).

%%%%%%%%%
% ARITY %
%%%%%%%%%

% each arity must have an associated connective type
:- arity(T, _), not connective_type(T).

% each connective type must have an associated arity
:- connective_type(T), not arity(T, _).

% a connective type can only have one arity
:- arity(T, N1), arity(T, N2), N1 != N2.

%%%%%%%%%%%%%
% INPUTS %
%%%%%%%%%%%%%

input(F, 1..A) :- connective(F, T), arity(T, A).

%%%%%%%%%%%%%%
% CONNECTION %
%%%%%%%%%%%%%%

% formula canlnot be connected to itself
:- connection(Fout, Fin, _), Fout = Fin.

% No cycles
path(F1, F2) :- connection(F1, F2, _).
path(F1, F3) :- path(F1, F2), path(F2, F3).
:- path(F, F).

% every formula has to have all its inputs connected
:- formula(F, conn), input(F, I), not connection(_, F, I).

%%%%%%%%%%
% MODELS %
%%%%%%%%%%

models(F, Num) :- formula(F, _), #max{N: model(F, N, _)} = Num.

model(F, 1, L) :- formula(F, atom), L = F.

contr(F) :- model(F, C, L), model(F, C, -L).

clause(F, C) :- model(F, C, _).

%%%%%%%%%%%%%%%%%
% SATISIFCATION %
%%%%%%%%%%%%%%%%%

clauses(F, N) :- #count{C: clause(F, C)} = N, formula(F, _). %model(F, _, _).
literals(F, C, N) :- clause(F, C), #count{L: model(F, C, L)} = N.

% C2 is subsumed by C1
subsumes(F1, C1, F2, C2) :-
    clause(F1, C1),
    clause(F2, C2),
    literals(F2, C2, N),
    #count{L: model(F2, C2, L), model(F1, C1, L)} = N.

% C2 is subsumed by a clause in F1
subsumes(F1, F2, C2) :-
    clause(F2, C2),
    clauses(F1, N),
    #count{C1: subsumes(F1, C1, F2, C2)} > 0.

% All the clauses in F2 are subsumed by a clause in C1
subsumes(F1, F2) :-
    model(F1, _, _),
    model(F2, _, _),
    clauses(F2, N),
    #count{C2: subsumes(F1, F2, C2)} = N.

%:- model(F1, _, _), model(F2, _, _), not subsumes(F2, F1), not contr(F1), entails(F1, F2).
entails(F1, F2) :- model(F1, _, _), model(F2, _, _), subsumes(F2, F1), F1 != F2.
entails(F1, F2) :- model(F1, _, _), model(F2, _, _), contr(F1), F1 != F2.

#show model/3.
