
{assign(V, G, 1): valuation(V)} = N / 2 :- gate_type(G, source), atomCount(N).
assign(V, G, 0) :- not assign(V, G, 1), valuation(V), gate_type(G, source).
