% Not

type(not_g).
arity(not_g, input, 1).
arity(not_g, output, 1).

eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), eval(S, _, _, G1, N1, 1), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), eval(S, _, _, G1, N1, 0), valuation(S).
