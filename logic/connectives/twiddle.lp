% Twiddle

type(twiddle_g).
arity(twiddle_g, input, 2).
arity(twiddle_g, output, 1).

:- connection(Gout, _, Gin, _), connective_type(Gout, twiddle_g), not connective_type(Gin, destination).

eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, twiddle_g), eval(S, _, _, F1, 1, 0), eval(S, _, _, F1, 2, 0), valuation(S).
eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, twiddle_g), eval(S, _, _, F1, 1, 0), eval(S, _, _, F1, 2, 1), valuation(S).
eval(S, F1, N1, F2, N2, 0) :- connection(F1, N1, F2, N2), connective_type(F1, twiddle_g), eval(S, _, _, F1, 1, 1), eval(S, _, _, F1, 2, 0), valuation(S).
eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, twiddle_g), eval(S, _, _, F1, 1, 1), eval(S, _, _, F1, 2, 1), valuation(S).
