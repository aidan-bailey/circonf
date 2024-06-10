% Every input needs a connection
:- terminal(G, N, tin), not connection(_, _, G, N).

% A gate must have at least one output connection if its arityout is greater than 0
N = 0 :- gate(G), gate_type(G, T), arity(T, N, tout), not connection(G, _, _, _).
