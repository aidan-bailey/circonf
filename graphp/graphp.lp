
%%%%%%%%%%%%%%%%%%%%
% GRAPH DEFINITION %
%%%%%%%%%%%%%%%%%%%%

% node(Id)

% edge(A, B)
% A : node(A)
% B : node(B)

%%%%%%%%%%%%%%%%
% CONSTRUCTION %
%%%%%%%%%%%%%%%%

#const width = 10.
#const height = 10.

%col(1..width).
%row(1..height).

% cell(X, Y):
% X : 1..width
% Y : 1..height

cell(1..width, 1..height).

% place nodes

% choose a cell for each node
{place(cell(X, Y), A): cell(X, Y)} = 1 :- node(A).
% nodes cannot occupy the same cell
A1 = A2 :- place(C, A1), place(C, A2).

% place edges

S != F :- segment(E, S, F).
:- segment(E, S, F), segment(E, F, S).

% place segments

{segment(edge(A, B), cell(Xi, Yi), cell(Xf, Yf)): cell(Xi, Yi), cell(Xf, Yf), Xf = Xi + (0; 1; -1), Yf = Yi + (0; 1; -1)} :- edge(A, B).

path(E, Ci, Cf) :- segment(E, Ci, Cf).
path(E, C1, C3) :- path(E, C1, C2), path(E, C2, C3), not place(C2, _).
:- path(E, C, C).

:- edge(A, B), not path(edge(A, B), Ci, Cf), place(Ci, A), place(Cf, B).

continued(segment(E, C1, C2)) :- segment(E, C1, C2), segment(E, C2, _).
ended(segment(edge(A, B), C1, C2)) :- segment(edge(A, B), C1, C2), place(C2, B).
started(segment(edge(A, B), C1, C2)) :- segment(edge(A, B), C1, C2), place(C1, A).

:- segment(E, C1, C2), not continued(segment(E, C1, C2)), not started(segment(E, C1, C2)), not ended(segment(E, C1, C2)).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

segments(N) :- #count{E, C1, C2: segment(E, C1, C2)} = N.

#minimize{N: segments(N)}.

%#show segments/1.

node(a;b;c;d).

edge(a,b).
edge(a,c).
edge(a,d).
