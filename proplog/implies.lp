connective_type(limpl).
arity(limpl, 2).

model(F, 1, -L) :- connective(F, limpl), connection(Fout, F, 1), model(Fout, C, L).

model(F, C + 1, L) :- connective(F, limpl), connection(Fout, F, 2), model(Fout, C, L).
