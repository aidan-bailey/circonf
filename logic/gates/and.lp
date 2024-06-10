% And

type(and_g).
arity(and_g, 2, input).
arity(and_g, 1, output).

eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 0), valuation(S).
