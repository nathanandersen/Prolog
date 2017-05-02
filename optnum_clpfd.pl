:- use_module(library(clpfd)).

% optnum(+L, ?K): the number of local optima in list L is K and the elements of L are pairwise non-equal.
% It can be assumed that L is proper (i.e., not open-ended). The elements of L as well as K are
% FD-variables or integers. optnum/2 should not perform labeling nor create any choice points.
optnum([_|_],0).

optnum([A,B,C|Rest],K) :-
  all_distinct([A,B,C|Rest]),
  K #> 0,
  ( B #> A, B #> C
  ; B #< A, B #< C),
  optnum([B,C|Rest],K1),
  K #= K1 + 1.

optnum([A,B,C|Rest],K) :-
  all_distinct([A,B,C|Rest]),
  K #> 0,
  optnum([B,C|Rest],K).
