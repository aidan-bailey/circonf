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

%:- model(F, _, _), not formula(F, _).

%model(F, 1, verum) :- constant(F, verum).

%model(F, 1, falsum) :- constant(F, falsum).

model(F, 1, L) :- formula(F, atom), L = F.

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

clauses(F, N) :- #count{C: clause(F, C)} = N, model(F, _, _).
literals(F, C, N) :- clause(F, C), #count{L: model(F, C, L)} = N.

% C2 is subsumed by C1
subsumes(F1, C1, F2, C2) :-
    clause(F1, C1),
    clause(F2, C2),
    literals(F2, C2, N),
    #count{L: model(F2, C2, L), model(F1, C1, L)} = N.

% C2 is subsumed by all the clauses in F1
subsumes(F1, F2, C2) :-
    clause(F2, C2),
    clauses(F1, N),
    #count{C1: subsumes(F1, C1, F2, C2)} = N.

% all the clauses in F2 are subsumed by all the clauses in F1
subsumes(F1, F2) :-
    model(F1, _, _),
    model(F2, _, _),
    clauses(F2, N),
    #count{C2: subsumes(F1, F2, C2)} = N.

formulas(Kb, N) :-
    knowledgeBase(Kb, _),
    #count{F: knowledgeBase(Kb, F)} = N.

entails(F1, F2) :- model(F1, _, _), model(F2, _, _), contr(F1), F1 != F2.

entails(F1, F2) :- model(F1, _, _), model(F2, _, _), subsumes(F1, F2), F1 != F2.

model(Kb, 1, L) :- knowledgeBase(Kb, F), model(F, N, L), not model(F, N, -L).
model(Kb, 1, -L) :- knowledgeBase(Kb, F), model(F, N, -L), not model(F, N, L).

:- knowledgeBase(Kb, _), formula(F, _), Kb = F.

%%%%%%%%%%%%

atom(a).
atom(b).

connective(andgate, andg).
connection(a, andgate, 1).
connection(b, andgate, 2).


knowledgeBase(kb1, a).
knowledgeBase(kb1, b).

#show entails/2.
%#show knowledgeBase/2.
