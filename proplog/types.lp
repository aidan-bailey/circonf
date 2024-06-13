%%%%%%%%%%%
% FORMULA %
%%%%%%%%%%%

formula_type(atom; const; conn).

% a named formula can only have one type
T1 = T2 :- formula(N, T1), formula(N, T2).

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

io(out).

connective_type(org).
arity(org, 2).

connective_type(andg).
arity(andg, 2).

connective_type(notg).
arity(notg, 1).

formula(F, conn) :- connective(F, T), connective_type(T).

%%%%%%%%%%%%%
% INPUTS %
%%%%%%%%%%%%%

input(F, 1..A) :- connective(F, T), arity(T, A).

%%%%%%%%%%%%%%
% CONNECTION %
%%%%%%%%%%%%%%

:- formula(F, conn), input(F, I), not connection(_, F, I).

%%%%%%%%%%
% MODELS %
%%%%%%%%%%

%models(F, 1) :- formula(F, atom).

models(F, Num) :- formula(F, _), #max{N: model(F, N, _)} = Num.

:- model(F, _, _), not formula(F, _).

model(F, 1, L) :- formula(F, atom), L = lit(F).

model(F, 1, L) :- connective(F, org), connection(Fout, F, 1), model(Fout, C, L).
model(F, 2, L) :- connective(F, org), connection(Fout, F, 2), model(Fout, C, L).

model(F, 1, L) :- connective(F, andg), connection(Fout, F, 1), model(Fout, C, L).
model(F, 1, L) :- connective(F, andg), connection(Fout, F, 2), model(Fout, C, L).

model(F, 1, L) :- connective(F, notg), connection(Fout, F, 1), model(Fout, C, -L), not model(Fout, C, L).
model(F, 1, -L) :- connective(F, notg), connection(Fout, F, 1), model(Fout, C, L), not model(Fout, C, -L).

contr(F) :- model(F, C, L), model(F, C, -L).

clause(F, C) :- model(F, C, _).

%%%%%%%%%%%%%%%%%
% SATISIFCATION %
%%%%%%%%%%%%%%%%%

clauses(F, N) :- #count{C: clause(F, C)} = N, formula(F, _).
literals(F, C, N) :- clause(F, C), #count{L: model(F, C, L)} = N.

%subsumes(F1, C1, F2, C2) :-
%    clause(F1, C1),
%    clause(F2, C2),
%    literals(F1, C1, N),
%    #count{L: model(F2, C2, L), model(F1, C1, L)} = N.

subsumes(F1, C1, F2, C2) :-
    clause(F1, C1),
    clause(F2, C2),
    literals(F2, C2, N),
    #count{L: model(F2, C2, L), model(F1, C1, L)} = N.



entails(F2, F1) :- formula(F1, _), formula(F2, _), contr(F2).

entails(F2, F1) :-
    formula(F1, _),
    formula(F2, _),
    clauses(F2, N),
    F1 != F2,
    #count{C1: subsumes(F1, C1, F2, C2)} = N.

%%%%%%%%%%%%

atom(a).
atom(b).

connective(orgate, org).
connection(a, orgate, 1).
connection(b, orgate, 2).

connective(andgate, andg).
connection(a, andgate, 1).
connection(b, andgate, 2).

#show entails/2.
%#show model/3.
