% And

type(and_g).
arity(and_g, 2, tin).
arity(and_g, 1, tout).

val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 1), val(S, _, _, G1, 2, 0), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 1), state(S).
val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, and_g), val(S, _, _, G1, 1, 0), val(S, _, _, G1, 2, 0), state(S).
