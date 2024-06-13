% Xor

type(xor_g).
arity(xor_g, input, 2).
arity(xor_g, output, 1).

eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), connective_type(G1, xor_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), connective_type(G1, xor_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), connective_type(G1, xor_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), connective_type(G1, xor_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 1), valuation(S).
