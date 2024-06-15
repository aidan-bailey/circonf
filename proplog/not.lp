connective_type(lnot).
arity(lnot, 1).

model(F, C, L) :- connective(F,lnot), connection(Fout, F, 1), model(Fout, C, -L).
model(F, C, -L) :- connective(F,lnot), connection(Fout, F, 1), model(Fout, C, L).
