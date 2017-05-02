:- use_module(library(clpfd)).

% draw(+G, -L): Graph G and line L describe the same graph.
draw(G, L) :-
  length(G, N),length(L, N),
  line(L),
  length(Vars,N),
  domain(Vars,1,N),
  all_distinct(Vars),
  labeling([],Vars),
  same(G,L,Vars).

% same(G,L,Vars): Graph G and line L describe the same graph,
% Vars : [V1,V2,...Vn], where Vi = j means that Gi = Lj.
% Note that Gi = A-B, so Lj = A-B OR B-A ( could be switched ).
same(G,L,Vars) :-
  split(L,LA,LB),
  same1(G,LA,LB,Vars).

same1([],_,_,[]).
same1([Edge|Rest],LA,LB,[V|Vars]) :-
  ( Edge = A-B
  ; Edge = B-A),
  element(V,LA,A),
  element(V,LB,B),
  same(Rest,LA,LB,Vars).

% line(+L) is a line. L is a proper list, but is not necessarily ground.
line([_-Y,Y-_]) :- !.
line([_-Y,Y-Z|Rest]) :- line([_-Z|Rest]).


% split(+LAB, -LA, -LB): LAB is a list of pairs of form A-B, LA is the list of As,
% and LB is the list of Bs. LAB is proper, but not necessarily ground.
split([],[],[]) :- !.
split([X-Y|Rest],[X|Xs],[Y|Ys]) :- split(Rest,Xs,Ys).
