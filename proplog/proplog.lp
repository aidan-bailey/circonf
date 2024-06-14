#include "types.lp".
#include "twiddle.lp".
#include "baseRank.lp".

atom(p;b;f).

%connective(s1, limpl).
%connection(p, s1, 1).
%connection(b, s1, 2).

%connective(s2, twiddle).
%connection(b, s2, 1).
%connection(f, s2, 2).

connective(nf, lnot).
connection(f, nf, 1).

%connection(nf, s3, 2).

%connective(s3, limpl).
%connection(p, s3, 1).


knowledgeBase(kb, t).

#show defeasibleStatements/2.
