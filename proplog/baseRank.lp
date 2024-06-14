
defeasibleStatements(Kb, F) :- knowledgeBase(Kb, F), connective(F, twiddle).

classicalStatements(Kb, F) :- knowledgeBase(Kb, F), not connective(F, twiddle).

maxRanks(Kb, N) :- #count{A: antecedent(F, A), knowledgeBase(Kb, F)} = N, knowledgeBase(Kb, _).

%rankConflicts(Kb, A, 0) :- knowledgeBase(Kb, F), antecedent(F, A), entails(Kb, -A).

rank(Kb, F, 0) :- knowledgeBase(Kb, F).
rank(Kb, F, N) :- rank(Kb, F, N - 1), antecedent(F, A), entails(Kb, -A), maxRanks(Kb, M), N < M + 1.
