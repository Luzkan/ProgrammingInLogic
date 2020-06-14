% https://en.wikibooks.org/wiki/Prolog/Lists#The_append_predicate
% Środkowy is a test if [List] has element "X" in the middle
środkowy([X],X).

% "MiddleElement" is the middle of the [List] if "MiddleElement" is the middle of the list [ListCut]
% 	where [ListCut] is a list without first and last element
środkowy(List, MiddleElement) :-
    append([_ | ListCut], [ _ ], List),
	środkowy(ListCut, MiddleElement).

% środkowy([1, 2, 3, 4, 5], Y).
% środkowy([1, 2, 3, 4], X).