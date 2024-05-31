%%%%%%%%%
% INPUT %
%%%%%%%%%

#const nBoundryWidth = 5.
#const nBoundryHeight = 5.
#const nMinVertexDistance = 0.
#const nMaxVertexDistance = 100.

%%%%%%%%%%
% DEFINE %
%%%%%%%%%%

vertex(a;b;c;d).
edge(a, b; b, c; c, d).
square(1..nBoundryWidth, 1..nBoundryHeight).

nVertex(N) :- #count{V: vertex(V)} = N.
vertexDistance(V1, V2, N) :- V1 != V2, vertex(V1), vertex(V2),
                             node(X1, Y1, V1), node(X2, Y2, V2),
                             |X2 - X1| + |Y2 - Y1| = N.

%%%%%%%%%%%%
% GENERATE %
%%%%%%%%%%%%

% choose one square for each vertex
{node(X, Y, V): square(X, Y)} = 1 :- vertex(V).
V1 = V2 :- node(X, Y, V1), node(X, Y, V2).

% select a position for the wire to start for each edge
{wirestart(X, Y, X + (1; -1), Y, V1, V2); wirestart(X, Y, X, Y + (1; -1), V1, V2)} = 1 :- edge(V1, V2), node(X, Y, V1).
:- wirestart(X1, Y1, X2, Y2, V1, V2), not square(X2, Y2).

% select a position for the wire to end for each edge
{wireend(X + (1; -1), Y, X, Y, V1, V2); wireend(X, Y + (1; -1), X, Y, V1, V2)} = 1 :- edge(V1, V2), node(X, Y, V2).
:- wireend(X1, Y1, X2, Y2, V1, V2), not square(X1, Y1).

% a segment is an inner part of a wire
{segment(X, Y, X + (1; -1), Y, V1, V2): square(X, Y)} :- edge(V1, V2).
{segment(X, Y, X, Y + (1; -1), V1, V2): square(X, Y)} :- edge(V1, V2).
:- segment(X1, Y1, X2, Y2, V1, V2), not square(X2, Y2).

% segment is not contected to
-started(X1, Y1, X2, Y2, V1, V2) :- segment(X1, Y1, X2, Y2, V1, V2), not wirestart(_, _, X1, Y1, V1, V2), not segment(_, _, X1, Y1, V1, V2).

% segment is not continued
-finished(X1, Y1, X2, Y2, V1, V2) :- segment(X1, Y1, X2, Y2, V1, V2), not wireend(X2, Y2, _, _, V1, V2), not segment(X2, Y2, _, _, V1, V2).

%%%%%%%%%%%%%%%
% AGGERGATION %
%%%%%%%%%%%%%%%

wireLength(V1, V2, L) :- edge(V1, V2), #count{X, Y: segment(X, Y, _, _, V1, V2)} = L.
wireCount(N) :- #count{V1, V2: edge(V1, V2)} = N.
netWireLength(N) :- #sum{L, edge(V1, V2): wireLength(V1, V2, L)} = N.
meanWireLength(M) :- netWireLength(N), wireCount(C),  M = N / C.

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N < nMinVertexDistance.
:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N > nMaxVertexDistance.

% a segment cannot be left unfinished
:- segment(X1, Y1, X2, Y2, V1, V2),
   -finished(X1, Y1, X2, Y2, V1, V2).

% a segment cannot not be started.
:- segment(X1, Y1, X2, Y2, V1, V2),
   -started(X1, Y1, X2, Y2, V1, V2).

% a segment cannot exist on a wirestart
:- wirestart(X1, Y1, X2, Y2, V1, V2),
   not segment(X2, Y2, _, _, V1, V2).

% a segment cannot exist on a wirestart
:- wireend(X1, Y1, X2, Y2, V1, V2),
   not segment(_, _, X1, Y1, V1, V2).

% a segment cannot reverse on itself
:- segment(X1, Y1, X2, Y2, V1, V2),
   segment(X2, Y2, X1, Y1, V1, V2).

% a segment cannot go directly onto a component
:- segment(X1, Y1, X2, Y2, V1, V2),
   node(X2, Y2, _).

% a wire cannot split unless it comes from the same source
% wire cannot occupy the same space

:- segment(X, Y, _, _, V1, V2), segment(_, _, X, Y, V3, V4).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

#minimize{N: netWireLength(N)}.
