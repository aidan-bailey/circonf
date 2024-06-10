% Not

type(not_g).
arityin(not_g, 1).
arityout(not_g, 1).

val(S, G1, N1, G2, N2, 0) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 1), state(S).
val(S, G1, N1, G2, N2, 1) :- connection(G1, N1, G2, N2), gate_type(G1, not_g), val(S, _, _, G1, N1, 0), state(S).
