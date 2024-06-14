connective_type(notg).
arity(notg, 1).

model(F, 1, L) :- connective(F, notg), connection(Fout, F, 1), model(Fout, C, -L), not model(Fout, C, L).
model(F, 1, -L) :- connective(F, notg), connection(Fout, F, 1), model(Fout, C, L), not model(Fout, C, -L).
