% sublist(+Whole, ?Part, ?Before, ?Length, ?After): Part is a
% sublist of Whole such that there are Before number of elements in
% Whole before Part, After number of elements in Whole after Part
% and the length of Part is Length.

sublist(Whole,Part,Before,Length,After) :-
  append(Sublist,Postlist,Whole),
  append(Prelist,Part,Sublist),
  length(Part,Length),
  length(Prelist,Before),
  length(Postlist,After).
