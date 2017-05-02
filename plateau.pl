:- use_module(library(lists),[last/2]).

% plateau(L, I, Len): There is a plateau of length Len starting at the
% I-th position of list L.

plateau(List,Index,Length) :-
  StartsWithPair = [X,X|_], % a list that starts with a pair of the same, 'X'
  append(Pre,StartsWithPair,List), % split it into StartsWithPair and Pre
  \+ last(Pre,X), % Pre does not end with X
  length(Pre,I0),
  Index is I0 + 1,
  (   append(Xs,Post,StartsWithPair), % split Starts... into two lists
      \+ Post = [X|_] -> length(Xs,Length) % such that 'Post'
      % does not start with X.
  ).
