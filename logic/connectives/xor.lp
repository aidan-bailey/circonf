% Xor

type(xor_g).
arity(xor_g, input, 2).
arity(xor_g, output, 1).

eval(S, F1, N1, F2, N2, 0) :- connection(F1, N1, F2, N2), connective_type(F1, xor_g), eval(S, _, _, F1, 1, 0), eval(S, _, _, F1, 2, 0), valuation(S).
eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, xor_g), eval(S, _, _, F1, 1, 0), eval(S, _, _, F1, 2, 1), valuation(S).
eval(S, F1, N1, F2, N2, 1) :- connection(F1, N1, F2, N2), connective_type(F1, xor_g), eval(S, _, _, F1, 1, 1), eval(S, _, _, F1, 2, 0), valuation(S).
eval(S, F1, N1, F2, N2, 0) :- connection(F1, N1, F2, N2), connective_type(F1, xor_g), eval(S, _, _, F1, 1, 1), eval(S, _, _, F1, 2, 1), valuation(S).
