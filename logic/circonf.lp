#include "prelude.lp".
#include "connectives/not.lp".
#include "connectives/and.lp".
#include "connectives/or.lp".
#include "generate/assignments.lp".
#include "semantics.lp".

connective(x1).
connective_type(x1, source).

connective(x2).
connective_type(x2, source).

connective(1).
connective_type(1, and_g).

connection(x1, 1, 1, 1).
connection(x2, 1, 1, 2).
connection(1, 1, y1, 1).

connective(y1).
connective_type(y1, destination).

%%%%%%%%%%%%
% OPTIMISE %
%%%%%%%%%%%%

%#show connective_type/2.
%#show val/3.
%#show assign/3.


#show model/2.
#show entails/2.

%#show sourceGates/1.
