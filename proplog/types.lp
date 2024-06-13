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

model(F, 1, L) :- formula(F, atom), L = literal(F).

model(F, 1, L) :- formula(F, conn), connective(F, org), connection(Fout, F, 1), model(Fout, N, L).
model(F, 2, L) :- formula(F, conn), connective(F, org), connection(Fout, F, 2), model(Fout, N, L).
model(F, 3, L) :- formula(F, conn), connective(F, org), model(F, 1, L).
model(F, 3, L) :- formula(F, conn), connective(F, org), model(F, 2, L).

clause(F, C) :- model(F, C, _).

%model(F, N, M) :- formula(F, conn), connective(F, notg), connection(Fin, F, 1), model(Fin, N, -M).

%%%%%%%%%%%%%%%%%
% SATISIFCATION %
%%%%%%%%%%%%%%%%%

clauses(F, N) :- #count{C: clause(F, C)} = N, formula(F, _).
literals(F, C, N) :- clause(F, C), #count{L: model(F, C, L)} = N.

subsumes(F1, C1, F2, C2) :-
    clause(F1, C1),
    clause(F2, C2),
    literals(F1, C1, N),
    #count{L: model(F2, C2, L), model(F1, C1, L)} = N.

entails(F1, F2) :-
    formula(F1, _),
    formula(F2, _),
    clauses(F1, N),
    #count{C1: subsumes(F1, C1, F2, C2)} = N.

%%%%%%%%%%%%

atom(c).
atom(x1).
atom(x2).
connective(orgate, org).
%connective(notgate, notg).


connection(x1, orgate, 1).
connection(x2, orgate, 2).
%connection(orgate, notgate, 1).


%#show input/3.
%#show literal/1.

%#show entails/2.
%#show models/2.
%#show model/3.
%#show subsumes/4.
#show entails/2.
%#show clauses/2.
%#show literals/3.
