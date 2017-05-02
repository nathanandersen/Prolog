:- use_module(library(lists)).
:- use_module(library(clpfd)).

% sudoku_simple(?Matrix, +N): Matrix is an NxN matrix, containing integers between 1 and N.
% In each row and in each column, the numbers are pairwise different. sudoku_simple/2 should
% not perform labeling.
sudoku_simple(Matrix,N) :-
  length(Matrix,N),
  (foreach(Row,Matrix),param([N]) do length(Row,N),domain(Row,1,N)),
  transpose(Matrix,MatrixT),
  maplist(all_distinct,Matrix),
  maplist(all_distinct,MatrixT).
