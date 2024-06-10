#include "prelude.lp".
#include "gates/not.lp".
#include "gates/and.lp".
#include "gates/or.lp".
#include "gates/xor.lp".
#include "generate/gates.lp".

gate(x1).
gate_type(x1, source).

gate(x2).
gate_type(x2, source).

gate(x3).
gate_type(x3, source).

gate(y1).
gate_type(y1, destination).

gate(y2).
gate_type(y2, destination).

valuation(1; 2; 3; 4; 5; 6; 7; 8).

assign(1, x1, 0).
assign(1, x2, 0).
assign(1, x3, 0).
assign(1, y1, 0).
assign(1, y2, 0).

assign(2, x1, 1).
assign(2, x2, 0).
assign(2, x3, 0).
assign(2, y1, 1).
assign(2, y2, 0).

assign(3, x1, 0).
assign(3, x2, 1).
assign(3, x3, 0).
assign(3, y1, 1).
assign(3, y2, 0).

assign(4, x1, 0).
assign(4, x2, 0).
assign(4, x3, 1).
assign(4, y1, 1).
assign(4, y2, 0).

assign(5, x1, 1).
assign(5, x2, 1).
assign(5, x3, 0).
assign(5, y1, 0).
assign(5, y2, 1).

assign(6, x1, 0).
assign(6, x2, 1).
assign(6, x3, 1).
assign(6, y1, 0).
assign(6, y2, 1).

assign(7, x1, 1).
assign(7, x2, 1).
assign(7, x3, 1).
assign(7, y1, 1).
assign(7, y2, 1).

assign(8, x1, 1).
assign(8, x2, 0).
assign(8, x3, 1).
assign(8, y1, 0).
assign(8, y2, 1).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

#minimize{N: gateCount(N)}.

#show gate_type/2.
#show con/2.

%#show sourceGates/1.
