
#const nBoundryWidth = 10.
#const nBoundryHeight = 10.
#const nMinVertexDistance = 5.
#const nMaxVertexDistance = 10.

% DEFINE

vertex(a;b).
edge(a, b).

square(1..nBoundryWidth, 1..nBoundryHeight).

nVertex(N) :- #count{V: vertex(V)} = N.

% GENERATE

{node(X, Y, V): square(X, Y)} = 1 :- nVertex(N), vertex(V).

node(1, 1, a).
node(5, 5, b).

node(3, 2, c).
node(2, 5, d).
edge(c, d).

{wirestart(X, Y, X + (1; -1), Y, V1, V2); wirestart(X, Y, X, Y + (1; -1), V1, V2)} = 1 :- edge(V1, V2), node(X, Y, V1).
:- wirestart(X1, Y1, X2, Y2, V1, V2), not square(X2, Y2).

{wireend(X + (1; -1), Y, X, Y, V1, V2); wireend(X, Y + (1; -1), X, Y, V1, V2)} = 1 :- edge(V1, V2), node(X, Y, V2).
:- wireend(X1, Y1, X2, Y2, V1, V2), not square(X1, Y1).

{segment(X, Y, X + (1; -1), Y, V1, V2): square(X, Y)} :- edge(V1, V2).
{segment(X, Y, X, Y + (1; -1), V1, V2): square(X, Y)} :- edge(V1, V2).
:- segment(X1, Y1, X2, Y2, V1, V2), not square(X2, Y2).

-started(X1, Y1, X2, Y2, V1, V2) :- segment(X1, Y1, X2, Y2, V1, V2), not wirestart(_, _, X1, Y1, V1, V2), not segment(_, _, X1, Y1, V1, V2).
-finished(X1, Y1, X2, Y2, V1, V2) :- segment(X1, Y1, X2, Y2, V1, V2), not wireend(X2, Y2, _, _, V1, V2), not segment(X2, Y2, _, _, V1, V2).

:- segment(X1, Y1, X2, Y2, V1, V2),
   -finished(X1, Y1, X2, Y2, V1, V2).

:- segment(X1, Y1, X2, Y2, V1, V2),
   -started(X1, Y1, X2, Y2, V1, V2).

:- wirestart(X1, Y1, X2, Y2, V1, V2),
   not segment(X2, Y2, _, _, V1, V2).

:- wireend(X1, Y1, X2, Y2, V1, V2),
   not segment(_, _, X1, Y1, V1, V2).

:- segment(X1, Y1, X2, Y2, V1, V2),
   segment(X2, Y2, X1, Y1, V1, V2).

:- segment(X1, Y1, X2, Y2, V1, V2),
   node(X2, Y2, _).

% TEST

vertexDistance(V1, V2, N) :- V1 != V2, vertex(V1), vertex(V2), node(X1, Y1, V1), node(X2, Y2, V2), |X2 - X1| + |Y2 - Y1| = N.

wireLength(V1, V2, N) :- #count{X, Y: segment(X, Y, _, _, V1, V2)} = N, edge(V1, V2).

:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N < nMinVertexDistance.
:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N > nMaxVertexDistance.

#show wirestart/6.
#show wireend/6.
#show segment/6.
#show -finished/6.
#show -started/6.
%#show -continued/6.
%#show segment/6.

#minimize{N: wireLength(V1, V2, N)}.
