connective_type(lnot).
arity(lnot, 1).

model(F, 1, L) :- connective(F,lnot), connection(Fout, F, 1), model(Fout, C, -L), not model(Fout, C, L).
model(F, 1, -L) :- connective(F,lnot), connection(Fout, F, 1), model(Fout, C, L), not model(Fout, C, -L).
