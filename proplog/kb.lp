{ordering(Kb, F, I): I = 1..N} = 1 :- formulas(Kb, N), knowledgeBase(Kb, F).
:- ordering(Kb, F1, I), ordering(Kb, F2, I), F1 != F2.

clauseUp(Kb, 0, 1) :- knowledgeBase(Kb, _).
clauseUp(Kb, I, Nf) :- ordering(Kb, F, I), clauseUp(Kb, I - 1, Ni), clauses(F, N), Nf = Ni * N.
clauses(Kb, N) :- #max{M: clauseUp(Kb, _, M)} = N, knowledgeBase(Kb, _).

clause(Kb, 1..N) :- clauses(Kb, N).

{join(Kb, C, F, C2): clause(Kb, C)} = N / FN :- clauses(Kb, N), clauses(F, FN), knowledgeBase(Kb, F), clause(F, C2).
:- join(Kb, C, F, C2), join(Kb, C, F, C1), C1 != C2.

model(Kb, C, L) :- join(Kb, C, F, C2), model(F, C2, L).

:- knowledgeBase(Kb, _), formula(F, _), Kb = F.

formulas(Kb, N) :-
    knowledgeBase(Kb, _),
    #count{F: knowledgeBase(Kb, F)} = N.
