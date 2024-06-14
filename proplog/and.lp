connective_type(land).
arity(land, 2).

model(F, 1, L) :- connective(F, land), connection(Fout, F, 1), model(Fout, C, L).
model(F, 1, L) :- connective(F, land), connection(Fout, F, 2), model(Fout, C, L).
