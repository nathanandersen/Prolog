:- use_module(library(clpfd)).

% visnum(+L, ?K): the number of elements in list L that are visible from the left is K.
% It can be assumed that L is proper (i.e., not open-ended). The elements of L as well as K are
% FD-variables or integers. visnum/2 should not perform labeling nor create any choice points.
visnum([_|_],1). % because the first is always visible
visnum([A,B|Rest],K) :-
  K #> 1,
  ( B #> A ->   visnum([B|Rest],K1), K #= K1+1
  ;             visnum([A|Rest],K)
  ).
