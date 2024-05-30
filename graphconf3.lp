
#const nBoundryWidth = 10.
#const nBoundryHeight = 10.
#const nMinVertexDistance = 2.
#const nMaxVertexDistance = 10.

% DEFINE

vertex(a;b;c;d).
edge(a, b).

square(1..nBoundryWidth, 1..nBoundryHeight).

nVertex(N) :- #count{V: vertex(V)} = N.

% GENERATE

{node(X, Y, V): square(X, Y)} = 1 :- nVertex(N), vertex(V).

{segment(X, Y, X + 1, Y): square(X, Y), X < nBoundryWidth}.
{segment(X, Y, X, Y + 1): square(X, Y), Y < nBoundryWidth}.
segment(X1, Y1, X2, Y2) :- segment(X2, Y2, X1, Y1).

line(X1, Y1, X2, Y2) :- segment(X1, Y1, X2, Y2).
line(X1, Y1, X3, Y3) :- segment(X1, Y1, X2, Y2), segment(X2, Y2, X3, Y3), not node(X2, Y2, V), vertex(V).
connection(V1, V2) :- line(X1, Y1, X2, Y2), node(X1, Y1, V1), node(X2, Y2, V2), V1 != V2.

:- #{connection{V1, V2}}, edge(V1, V2).

% TEST

V1 = V2 :- node(X, Y, V1), node(X, Y, V2).
:- edge(V1, V2), not connection(V1, V2).

vertexDistance(V1, V2, N) :- V1 != V2, vertex(V1), vertex(V2), node(X1, Y1, V1), node(X2, Y2, V2), |X2 - X1| + |Y2 - Y1| = N.

:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N < nMinVertexDistance.
:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N > nMaxVertexDistance.
