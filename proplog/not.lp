connective_type(lnotg).
arity(lnotg, 1).

model(F, 1, L) :- connective(F, lnotg), connection(Fout, F, 1), model(Fout, C, -L), lnot model(Fout, C, L).
model(F, 1, -L) :- connective(F, lnotg), connection(Fout, F, 1), model(Fout, C, L), lnot model(Fout, C, -L).
