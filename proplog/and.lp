connective_type(land).
arity(land, 2).

%model(F, 1, L) :- connective(F, land), connection(Fout, F, 1), model(Fout, C, L).
%model(F, 1, L) :- connective(F, land), connection(Fout, F, 2), model(Fout, C, L).

model(F, C, L) :- connective(F, land), connection(Fin, F, 1), model(Fin, C, L).
model(F, C, L) :- connective(F, land),
                  connection(Fin1, F, 1), clause(Fin1, C),
                  connection(Fin2, F, 2), model(Fin2, _, L).
