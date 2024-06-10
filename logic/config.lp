disconnectedouts(0).
G1 = G2 :-
    spath(G1, G2), gate_type(G2, destination),
    spath(G2, G3), gate_type(G3, destination),
    disconnectedouts(1).
