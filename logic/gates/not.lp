% Not

type(not_g).
arity(not_g, 1, input).
arity(not_g, 1, output).

eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), eval(S, _, _, G1, N1, 1), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), eval(S, _, _, G1, N1, 0), valuation(S).
