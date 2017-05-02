:- use_module(library(lists)).

sudoku(Input,Output) :-
  replace_zeros(Input,Unbound),
  (   is_better_horizontally(Unbound) ->
      fill_rows(Unbound),
      consistent(Unbound),
      Output = Unbound
  ;   transpose(Unbound,UnboundT), % if not better horizontally, transpose and solve
      fill_rows(UnboundT),
      consistent(UnboundT),
      transpose(UnboundT,Output)
  ).

numlist(To,To,[To]) :- !.
numlist(From,To,[From|Rest]) :- From < To, F1 is From+1, numlist(F1,To,Rest).

sum_zeros_squared(Row,Sum) :-
  filter(Row,var,Vars,_), % could probably do this easier to reduce a constant factor
  length(Vars,V), Sum is V*V.

horiz_sum_squared(Rows,Sum) :-
  maplist(sum_zeros_squared,Rows,Ss),
  sumlist(Ss,Sum).

is_better_horizontally(Solvable) :-
  horiz_sum_squared(Solvable,Sum), % get the horiz sum
  transpose(Solvable,SolvableT),
  horiz_sum_squared(SolvableT,SumT), % get the vert sum (by transposing)
  SumT > Sum.

replace_zeros(Input,Rows) :- maplist(maplist(insert_var),Input,Rows). %  0 -> unbound variable

all_distinct(List) :- \+ (select(E,List,R), E \== 0, memberchk(E,R)).

is_bound(Rows) :- maplist(maplist(nonvar),Rows). % make sure everything is nonvariables

% Split a list by the predicate into FL, and failures into UFL.
filter([],_PG,[],[]).
filter([X|L], PG, FL, UFL) :-
  ( call(PG, X) -> FL = [X|FL1], UFL = UFL1
  ; FL = FL1, UFL = [X|UFL1]
  ), filter(L, PG, FL1,UFL1).

not_in(List,Ele) :- \+ memberchk(Ele,List).

fill_rows(Rows) :-
  length(Rows,N),
  numlist(1,N,Nums),
  maplist(fill_in(Nums),Rows).

fill_in(Nums,Row) :-
  filter(Row,var,Vars,Nonvars),
  filter(Nums,not_in(Nonvars),Choices,_),
  findall(P,permutation(Choices,P),Perms),
  select(Vars,Perms,_).
  % find all missing numbers in the row,
  % and map the unbound variables to a permutation
  % of the missing numbers.

insert_var(0,_) :- !. % map 0 to unbound variable.
insert_var(X,X).

consistent(Rows) :-
  maplist(all_distinct,Rows),
  transpose(Rows,Columns),
  maplist(all_distinct,Columns),
  make_sections(Rows,Sections),
  maplist(all_distinct,Sections).

make_sections(Rows,Sections) :-
  % Rows is 9x9
  length(Rows,N), % length is 9
  S is integer(sqrt(N)), % sqrt 3
  chop(S,Rows,Chunks),
  % Chunks is 3 x (3x9)
  maplist(make_sections(S),Chunks,TripleSections),
  % TripleSections is 3x(3x9) where each 9 is a list-section
  append(TripleSections,Sections).
  % Sections is 9x9 but in sections

make_sections(S,Chunk,Sections) :-
  % chunk is 3x9
  transpose(Chunk,ChunkT),
  % chunkT is 9x3
  chop(S,ChunkT,SectionsList),
  % Sections is 3 x (3x3)
  maplist(append,SectionsList,Sections).
  % sections is 3x9

split(0,X,[],X).
split(N,[X|Ls],[X|F1],B) :-
  N > 0,
  N1 is N-1,
  split(N1,Ls,F1,B).

chop(_,[],[]).
% Chop an empty list, get an empty list.
chop(N,In,[In]) :-
  N > 0,
  length(In,I),
  I > 0,
  \+ N < I.
% Chop a list of length < N, get that list back.
chop(N,In,[Fs|Bs]) :-
  N > 0,
  length(In,I),
  I > 0,
  N < I,
  split(N,In,Fs,Rest),
  chop(N,Rest,Bs).
