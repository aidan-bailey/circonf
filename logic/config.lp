disconnectedouts(0).
F1 = F2 :-
    spath(F1, F2), connective_type(F2, destination),
    spath(F2, F3), connective_type(F3, destination),
    disconnectedouts(1).
