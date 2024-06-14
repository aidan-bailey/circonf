connective_type(twiddle).
arity(twiddle, 2).

% A twiddle must be the root
:- connection(F, _, _), connective(F, twiddle).

model(F, 1, L) :- connective(F, limpl), connection(Fout, F, 1), model(Fout, C, -L), not model(Fout, C, L).
model(F, 1, -L) :- connective(F, limpl), connection(Fout, F, 1), model(Fout, C, L), not model(Fout, C, -L).

model(F, C + 1, L) :- connective(F, limpl), connection(Fout, F, 2), model(Fout, C, L).
