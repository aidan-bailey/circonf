%%%%%%%%%
% INPUT %
%%%%%%%%%

#const nBoundryWidth = 6.
#const nBoundryHeight = 6.
#const nMinVertexDistance = 1.
#const nMaxVertexDistance = 10.

%%%%%%%%%%
% DEFINE %
%%%%%%%%%%

square(1..nBoundryWidth, 1..nBoundryHeight).

nVertex(N) :- #count{V: vertex(V)} = N.
vertexDistance(V1, V2, N) :- V1 != V2, vertex(V1), vertex(V2),
                             node(square(X1, Y1), V1), node(square(X2, Y2), V2),
                             |X2 - X1| + |Y2 - Y1| = N.

%%%%%%%%%%%%
% GENERATE %
%%%%%%%%%%%%

% choose one square for each vertex
{node(square(X, Y), V): square(X, Y)} = 1 :- vertex(V).
V1 = V2 :- node(S, V1), node(S, V2).

% select a position for the wire to start for each edge
{wirestart(square(X, Y), square(X + (1; -1; 0), Y + (1; -1; 0)), edge(V1, V2))} = 1 :- edge(V1, V2), node(square(X, Y), V1).
:- wirestart(_, square(X, Y), edge(V1, V2)), not square(X, Y).
:- wirestart(S, S, _).
E1 = E2 :- wirestart(S1, S2, E1), wirestart(S1, S2, E2).

% select a position for the wire to end for each edge
{wireend(square(X + (1; -1; 0), Y + (1; -1; 0)), square(X, Y), edge(V1, V2))} = 1 :- edge(V1, V2), node(square(X, Y), V2).
:- wireend(square(X1, Y1), square(X2, Y2), edge(V1, V2)), not square(X1, Y1).
:- wireend(square(X, Y), square(X, Y), _).
E1 = E2 :- wireend(square(X, Y), square(X2, Y2), E1), wireend(square(X, Y), square(X2, Y2), E2).

:- segment(_, S, _), node(S, _).

% a segment is an inner part of a wire
{segment(square(X, Y), square(X + (1; -1; 0), Y + (1; -1; 0)), edge(E1, E2)): square(X, Y)} :- edge(E1, E2).
:- segment(square(X1, Y1), square(X2, Y2), edge(V1, V2)), not square(X2, Y2).
:- segment(S, S, _).
E1 = E2 :- segment(S1, S2, E1), segment(S1, S2, E2).
:- segment(S1, S2, _), segment(S2, S1, _).
:- segment(_, S, _), node(S, _).
:- segment(S, _, _), node(S, _).

% segment is not contected to
-started(S1, S2, edge(V1, V2)) :- segment(S1, S2, edge(V1, V2)), not wirestart(_, S1, edge(V1, V2)), not segment(_, S1, edge(V1, V2)).

% segment is not continued
-finished(S1, S2, edge(V1, V2)) :- segment(S1, S2, edge(V1, V2)), not wireend(S2, _, edge(V1, V2)), not segment(S2, _, edge(V1, V2)).

%%%%%%%%%%%%%%%
% AGGERGATION %
%%%%%%%%%%%%%%%

wireLength(edge(V1, V2), L) :- edge(V1, V2), #count{S: segment(S, _, edge(V1, V2))} = L.
wireCount(N) :- #count{V1, V2: edge(V1, V2)} = N.
netWireLength(N) :- #sum{L, edge(V1, V2): wireLength(edge(V1, V2), L)} = N.
meanWireLength(M) :- netWireLength(N), wireCount(C),  M = N / C.

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

%:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N < nMinVertexDistance.
%:- vertex(V1), vertex(V2), vertexDistance(V1, V2, N), N > nMaxVertexDistance.

% a segment cannot be left unfinished
:- segment(S1, S2, E),
   -finished(S1, S2, E).

% a segment cannot not be started.
:- segment(S1, S2, E),
   -started(S1, S2, E).

% a segment cannot exist on a wirestart
:- wirestart(S1, S2, E),
   not segment(S2, _, E).

% a segment cannot exist on a wirestart
:- wireend(S1, S2, E),
   not segment(_, S1, E).

% a segment cannot reverse on itself
:- segment(S1, S2, E),
   segment(S2, S1, E).

% a segment cannot go directly onto a component
:- segment(S1, S2, E),
   node(S2, _).

%E1 = E2 :- segment(X1, Y1, X2, Y2, E1), segment(X1, Y1, X2, Y2, E2).
E1 = E2 :- segment(_, S, E1), segment(_, S, E2).
E1 = E2 :- segment(_, S, E1), wirestart(_, S, E2).
E1 = E2 :- segment(_, S, E1), wireend(S, _, E2).

S2 = S3 :- segment(S1, S2, E), segment(S1, S3, E).
S1 = S2 :- segment(S1, S3, E), segment(S2, S3, E).

path(S1, S2, E) :- segment(S1, S2, E).
path(S1, S3, E) :- segment(S1, S2, E), path(S2, S3, E).
cycle(E) :- path(S1, S2, E), path(S2, S1, E).
:- cycle(E).

%:- segment(S1, _, E1), segment(S2, _, E2), E1 != E2.

E1 = E2 :- segment(S, _, E1), segment(S, _, E2).

:- segment(S1, S2, E), segment(S2, S3, E), wirestart(_, S2, _).
:- segment(S1, S2, E), segment(S2, S3, E), wireend(S2, _, _).

wingding(S1, S2, E) :- segment(S1, S2, E).
wingding(S1, S2, E) :- wirestart(S1, S2, E).
wingding(S1, S2, E) :- wireend(S1, S2, E).

crossing(E1, E2) :- wingding(square(X, Y), square(X + 1, Y + 1), E1), wingding(square(X, Y + 1), square(X + 1, Y), E2).
crossing(E1, E2) :- wingding(square(X, Y), square(X + 1, Y + 1), E1), wingding(square(X + 1, Y), square(X, Y + 1), E2).
crossing(E1, E2) :- wingding(square(X, Y), square(X - 1, Y - 1), E1), wingding(square(X - 1, Y), square(X, Y - 1), E2).
crossing(E1, E2) :- wingding(square(X, Y), square(X - 1, Y - 1), E1), wingding(square(X, Y - 1), square(X - 1, Y), E2).

:- nCrossingEdges(N), N > (Ne * Ne), nEdges(Ne).
nCrossingEdges(N) :- #count{W1, W2: crossing(W1, W2)} = N.
:- nCrossingEdges(N1), nCrossingEdges(N2), N1 != N2.

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

nEdges(N) :- #count{V1, V2: edge(V1, V2)} = N.

%:- netWireLength(N), N > 27.
:- netWireLength(N1), netWireLength(N2), N1 != N2.

%#maximize{N: nCrossingEdges(N)}.
%#minimize{N: netWireLength(N)}.
%#minimize{N: nCrossingEdges(N)}.

vertex(a;b;c;d;e).
edge(a, b; b, c; c, d).
edge(a, e; b, e; c, e; d, e).

%nCrossingEdges(8). netWireLength(25).
%nCrossingEdges(7). netWireLength(27).
%:- nCrossingEdges(N), N < 7.
%:- netWireLength(N), N < 25.

#show nCrossingEdges/1.
#show netWireLength/1.