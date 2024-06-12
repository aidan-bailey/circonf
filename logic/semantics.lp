model(Formula, V) :- formula(Formula, _), valuation(V), val(V, Formula, 1).

entails(A, B) :- model(A, V), model(B, V).

knowledgeBase(Formula) :- formula(Formula, _).
