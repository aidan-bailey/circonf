connective_type(lor).
arity(lor, 2).

model(F, 1, L) :- connective(F, lor), connection(Fout, F, 1), model(Fout, C, L).
model(F, 2, L) :- connective(F, lor), connection(Fout, F, 2), model(Fout, C, L).
