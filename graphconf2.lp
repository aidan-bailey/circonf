
#const nBoundryWidth = 2.
#const nBoundryHeight = 2.

% DEFINE

vertex(a; b).
edge(a, b).

square(1..nBoundryWidth, 1..nBoundryHeight).

nVertex(N) :- #count{V: vertex(V)} = N.

step(X1, Y1, X2 + (1;-1), Y2 + (1;-1)) :- stepstone(X1, Y1), square(X2, Y2).

path(X1, Y1, X2, Y2) :- step(X1, Y1, X2, Y2).
path(X1, Y1, X3, Y3) :- path(X1, Y1, X2, Y2), path(X1, Y1, X3, Y3), not node(X2, Y2, _).

connected(V1, V2) :- node(X1, Y1, V1), node(X2, Y2, V2), path(X1, Y1, X2, Y2).

% GENERATE

{node(X, Y, V): square(X, Y)} = 1 :- nVertex(N), vertex(V).

% TEST

% a step and a node cannot exist in the same square
:- stepstone(X, Y), node(X, Y, _).

% two nodes cannot exist in the same square
V1 = V2 :- node(X, Y, V1), node(X, Y, V2).

%:- edge(V1, V2), not connected(V1, V2).
%:- not edge(V1, V2), connected(V1, V2).

% OUTPUT

#show node/3.
#show step/4.
%#show connected/2.
