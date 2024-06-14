connective_type(org).
arity(org, 2).

model(F, 1, L) :- connective(F, org), connection(Fout, F, 1), model(Fout, C, L).
model(F, 2, L) :- connective(F, org), connection(Fout, F, 2), model(Fout, C, L).
