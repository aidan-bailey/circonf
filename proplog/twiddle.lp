connective_type(twiddle).
arity(twiddle, 2).

% A twiddle must be the root
:- connection(F, _, _), connective(F, twiddle).

model(F, 1, -L) :- connective(F, twiddle), connection(Fout, F, 1), model(Fout, C, L).
model(F, 2, L) :- connective(F, twiddle), connection(Fout, F, 2), model(Fout, C, L).

antecedent(F, A) :- connective(F, twiddle), connection(A, F, 1).
consequent(F, B) :- connective(F, twiddle), connection(B, F, 2).
