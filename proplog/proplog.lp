#include "types.lp".
#include "twiddle.lp".
#include "baseRank.lp".

%atom(p;f;b).

atom(p; b).

connective(s1, twiddle).
connection(p, s1, 1).
connection(b, s1, 2).

%connective(s2, twiddle).
%connection(b, s2, 1).
%connection(f, s2, 2).

%connective(s3, twiddle).
%connection(p, s3, 1).
%connective(nf, lnot).
%connection(f, nf, 1).
%connection(nf, s3, 2).


%knowledgeBase(kb, s1).
%knowledgeBase(kb, (s1;s2;s3)).

%#show defeasibleStatements/2.
%#show classicalStatements/2.
%#show entails/2.
%#show model/3.
%#show join/4.
%#show clauses/2.
%#show join/4.
%show antecedent/2.
%#show knowledgeBase/2.
%#show rankConflicts/3.
%#show maxRanks/2.

%#show rank/3.
%#show contr/1.

%#show connection/3.
