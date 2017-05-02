:- use_module(library(lists),[select/3,same_length/2]).

collinear([_-_]).
collinear([_-Y,Y-Z|L]) :-
  collinear([Y-Z|L]).

same([],[]).
same(G,[A-B|Line]) :-
  (   select(A-B,G,Rest)
  ;   select(B-A,G,Rest)
  ), same(Rest,Line).

% draw(+G, -L): Graph G and line L describe the same graph.
draw(G,L) :-
  same_length(G,L),
  collinear(L),
  same(G,L).
