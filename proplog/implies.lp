connective_type(implg).
arity(implg, 2).

model(F, 1, L) :- connective(F, implg), connection(Fout, F, 1), model(Fout, C, -L), not model(Fout, C, L).
model(F, 1, -L) :- connective(F, implg), connection(Fout, F, 1), model(Fout, C, L), not model(Fout, C, -L).

model(F, C + 1, L) :- connective(F, implg), connection(Fout, F, 2), model(Fout, C, L).
