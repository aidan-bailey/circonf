% Or

type(or_g).
arity(or_g, input, 2).
arity(or_g, output, 1).

eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, or_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 1), valuation(S).
