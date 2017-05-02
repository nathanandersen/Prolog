:- use_module(library(lists)).
:- use_module(library(clpfd)).

% knapsack(+Items, +MaxWeight, +MinValue, ?Selected): Items is a list of items of the form
% item(Id,Weight,Value), where Id, Weight, and Value are given positive integers; Id is a
% unique identifier of the item, whereas Weight and Value specify its weight and value.
% MaxWeight and MinValue are given positive integers specifying the capacity of the knapsack
% and the minimum total value of the items to be selected, respectively. Selected should be a
% list of the identifiers of the selected items, in the same order as they appear in Items.
% knapsack/4 should include labeling.
knapsack(Items,MaxWeight,MinValue,Selected) :-
  length(Items,N),
  length(Vars,N),
  domain(Vars,0,1),
  values(Items,Values),
  weights(Items,Weights),
  labeling([],Vars),
  scalar_product(Values,Vars,#>=,MinValue),
  scalar_product(Weights,Vars,#=<,MaxWeight),
  create_output(Items,Vars,Choices),
  ids(Choices,Selected).


item_id(item(Id,_,_),Id).
item_weight(item(_,Weight,_),Weight).
item_value(item(_,_,Value),Value).

ids([],[]).
ids([Item|Items],[Id|Ids]) :-
  item_id(Item,Id),
  ids(Items,Ids).

values([],[]).
values([Item|Items],[Value|Values]) :-
  item_value(Item,Value),
  values(Items,Values).

weights([],[]).
weights([Item|Items],[Weight|Weights]) :-
  item_weight(Item,Weight),
  weights(Items,Weights).

create_output([],[],[]).
create_output([X|L1],[1|Vars],[X|L2]) :-
  create_output(L1,Vars,L2).
create_output([_|L1],[0|Vars],L2) :-
  create_output(L1,Vars,L2).
