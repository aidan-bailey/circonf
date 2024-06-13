disconnectedouts(0).
F1 = F2 :-
    spath(F1, F2), connective_type(F2, destination),
    spath(F2, G3), connective_type(G3, destination),
    disconnectedouts(1).
