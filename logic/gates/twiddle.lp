% Twiddle

type(twiddle_g).
arity(twiddle_g, input, 2).
arity(twiddle_g, output, 1).

:- connection(Gin, _, Gout, _), gate_type(Gin, twiddle_g), not gate_type(Gout, destination).

eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 1), valuation(S).
