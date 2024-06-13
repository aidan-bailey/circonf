
{assign(V, G, 1): valuation(V)} = N / 2 :- connective_type(G, atom), valuationCount(N).
assign(V, G, 0) :- not assign(V, G, 1), valuation(V), connective_type(G, atom).
