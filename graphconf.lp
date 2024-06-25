%%%%%%%%%
% INPUT %
%%%%%%%%%

#const nBoundryWidth = 6.
#const nBoundryHeight = 6.
#const nMinVertexDistance = 2.
#const nMaxVertexDistance = 10.

%%%%%%%%%%
% DEFINE %
%%%%%%%%%%

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
%{wirestart(X, Y, X + (1; -1), Y, edge(V1, V2)); wirestart(X, Y, X, Y + (1; -1), edge(V1, V2))} = 1 :- edge(V1, V2), node(X, Y, V1).
{wirestart(X, Y, X + (1; -1; 0), Y + (1; -1; 0), edge(V1, V2))} = 1 :- edge(V1, V2), node(X, Y, V1).
:- wirestart(X1, Y1, X2, Y2, edge(V1, V2)), not square(X2, Y2).
:- wirestart(X, Y, X, Y, _).
E1 = E2 :- wirestart(X, Y, X2, Y2, E1), wirestart(X, Y, X2, Y2, E2).

% select a position for the wire to end for each edge
%{wireend(X + (1; -1), Y, X, Y, edge(V1, V2)); wireend(X, Y + (1; -1), X, Y, edge(V1, V2))} = 1 :- edge(V1, V2), node(X, Y, V2).
{wireend(X + (1; -1; 0), Y + (1; -1; 0), X, Y, edge(V1, V2))} = 1 :- edge(V1, V2), node(X, Y, V2).
:- wireend(X1, Y1, X2, Y2, edge(V1, V2)), not square(X1, Y1).
:- wireend(X, Y, X, Y, _).
E1 = E2 :- wireend(X, Y, X2, Y2, E1), wireend(X, Y, X2, Y2, E2).

touching(edge(V1, V2)) :- wirestart(_, _, X2, Y2, edge(V1, V2)), wireend(X2, Y2, _, _, edge(V1, V2)).
touching(edge(V1, V2)) :- wirestart(_, _, X2, Y2, edge(V1, V2)), wireend(X2, Y2, _, _, edge(V1, V2)).

:- segment(_, _, X, Y, _), node(X, Y, _).

% a segment is an inner part of a wire
%{segment(X, Y, X + (1; -1), Y, edge(V1, V2)): square(X, Y)} :- edge(V1, V2), not touching(edge(V1, V2)).
%{segment(X, Y, X, Y + (1; -1), edge(V1, V2)): square(X, Y)} :- edge(V1, V2), not touching(edge(V1, V2)).
{segment(X, Y, X + (1; -1; 0), Y + (1; -1; 0), edge(V1, V2)): square(X, Y)} :- edge(V1, V2), not touching(edge(V1, V2)).
:- segment(X1, Y1, X2, Y2, edge(V1, V2)), not square(X2, Y2).
:- segment(X, Y, X, Y, _).
E1 = E2 :- segment(X, Y, X2, Y2, E1), segment(X, Y, X2, Y2, E2).
:- segment(X2, Y2, X, Y, _), segment(X, Y, X2, Y2, _).
:- segment(_, _, X, Y, _), node(X, Y, _).
:- segment(X, Y, _, _, _), node(X, Y, _).

% segment is not contected to
-started(X1, Y1, X2, Y2, edge(V1, V2)) :- segment(X1, Y1, X2, Y2, edge(V1, V2)), not wirestart(_, _, X1, Y1, edge(V1, V2)), not segment(_, _, X1, Y1, edge(V1, V2)).

% segment is not continued
-finished(X1, Y1, X2, Y2, edge(V1, V2)) :- segment(X1, Y1, X2, Y2, edge(V1, V2)), not wireend(X2, Y2, _, _, edge(V1, V2)), not segment(X2, Y2, _, _, edge(V1, V2)).

%%%%%%%%%%%%%%%
% AGGERGATION %
%%%%%%%%%%%%%%%

wireLength(edge(V1, V2), L) :- edge(V1, V2), #count{X, Y: segment(X, Y, _, _, edge(V1, V2))} = L.
wireCount(N) :- #count{V1, V2: edge(V1, V2)} = N.
netWireLength(N) :- #sum{L, edge(V1, V2): wireLength(edge(V1, V2), L)} = N.
meanWireLength(M) :- netWireLength(N), wireCount(C),  M = N / C.

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

%:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N < nMinVertexDistance.
%:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N > nMaxVertexDistance.

% a segment cannot be left unfinished
:- segment(X1, Y1, X2, Y2, edge(V1, V2)),
   -finished(X1, Y1, X2, Y2, edge(V1, V2)).

% a segment cannot not be started.
:- segment(X1, Y1, X2, Y2, edge(V1, V2)),
   -started(X1, Y1, X2, Y2, edge(V1, V2)).

% a segment cannot exist on a wirestart
:- wirestart(X1, Y1, X2, Y2, edge(V1, V2)),
   not segment(X2, Y2, _, _, edge(V1, V2)).

% a segment cannot exist on a wirestart
:- wireend(X1, Y1, X2, Y2, edge(V1, V2)),
   not segment(_, _, X1, Y1, edge(V1, V2)).

% a segment cannot reverse on itself
:- segment(X1, Y1, X2, Y2, edge(V1, V2)),
   segment(X2, Y2, X1, Y1, edge(V1, V2)).

% a segment cannot go directly onto a component
:- segment(X1, Y1, X2, Y2, edge(V1, V2)),
   node(X2, Y2, _).

% a wire cannot split unless it comes from the same source
%V1 = V3 :- segment(X, Y, _, _, edge(V1, V2)), segment(X, Y, _, _, edge(V3, V4)).

%E1 = E2 :- segment(X1, Y1, X2, Y2, E1), segment(X1, Y1, X2, Y2, E2).
E1 = E2 :- segment(_, _, X, Y, E1), segment(_, _, X, Y, E2).

%:- segment(X, Y, X, Y, E1), segment(_, _, X, Y, E2), E1 != E2.
%:- segment(X, Y, _,)

E1 = E2 :- segment(X, Y, _, _, E1), segment(X, Y, _, _, E2).

:- segment(X, Y, X2, Y2, E), segment(X2, Y2, X3, Y3, E), wirestart(_, _, X2, Y2, _).
:- segment(X, Y, X2, Y2, E), segment(X2, Y2, X3, Y3, E), wireend(X2, Y2, _, _, _).

wingding(X, Y, X2, Y2, E) :- segment(X, Y, X2, Y2, E).
wingding(X, Y, X2, Y2, E) :- wirestart(X, Y, X2, Y2, E).
wingding(X, Y, X2, Y2, E) :- wireend(X, Y, X2, Y2, E).

crossing(E1, E2) :- wingding(X, Y, X + 1, Y + 1, E1), wingding(X, Y + 1, X + 1, Y, E2).
crossing(E1, E2) :- wingding(X, Y, X + 1, Y + 1, E1), wingding(X + 1, Y, X, Y + 1, E2).
crossing(E1, E2) :- wingding(X, Y, X - 1, Y - 1, E1), wingding(X - 1, Y, X, Y - 1, E2).
crossing(E1, E2) :- wingding(X, Y, X - 1, Y - 1, E1), wingding(X, Y - 1, X - 1, Y, E2).

:- nCrossingEdges(N), N > (Ne * Ne), nEdges(Ne).
nCrossingEdges(N) :- #count{W1, W2: crossing(W1, W2)} = N.
:- nCrossingEdges(N1), nCrossingEdges(N2), N1 != N2.

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

nEdges(N) :- #count{V1, V2: edge(V1, V2)} = N.

%#maximize{N: nCrossingEdges(N)}.
%#maximize{N: netWireLength(N)}.
%#minimize{N: nCrossingEdges(N)}.

nCrossingEdges(0).

vertex(a;b;c;d).
edge(a, b; b, c).
edge(a, d; b, d; c, d).

#show nCrossingEdges/1.
#show netWireLength/1.