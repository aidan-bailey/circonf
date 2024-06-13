% Not

type(not_g).
arity(not_g, input, 1).
arity(not_g, output, 1).

eval(S, F1, N1, F2, N2, 0) :- connection(F1, N1, F2, N2), connective_type(F1, not_g), eval(S, _, _, F1, N1, 1), valuation(S).
eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, not_g), eval(S, _, _, F1, N1, 0), valuation(S).
