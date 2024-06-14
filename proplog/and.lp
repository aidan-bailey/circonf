connective_type(andg).
arity(andg, 2).

model(F, 1, L) :- connective(F, andg), connection(Fout, F, 1), model(Fout, C, L).
model(F, 1, L) :- connective(F, andg), connection(Fout, F, 2), model(Fout, C, L).
