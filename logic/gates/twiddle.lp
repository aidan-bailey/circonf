% Twiddle

type(twiddle_g).
arity(twiddle_g, input, 2).
arity(twiddle_g, output, 1).

:- connection(Gout, _, Gin, _), gate_type(Gout, twiddle_g), not gate_type(Gin, destination).

eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, twiddle_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, twiddle_g), eval(S, _, _, G1, 1, 0), eval(S, _, _, G1, 2, 1), valuation(S).
eval(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, twiddle_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 0), valuation(S).
eval(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, twiddle_g), eval(S, _, _, G1, 1, 1), eval(S, _, _, G1, 2, 1), valuation(S).
