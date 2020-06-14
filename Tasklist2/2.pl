% Take out some "X" from [L] and create [L1]
%	-> then test if there's still an "X" in [L1]
%	-> If there is still an "X" it means there were more than 1 "X" in [L]
%	-> Reverse of the statement if our result
jednokrotnie(X, L) :-
    select(X, L, L1),
    \+ member(X, L1).

% Repeat the action from above 
dwukrotnie(X, L) :- 
    select(X, L, L1),
	jednokrotnie(X, L1).

% jednokrotnie(X, [3, 2, 4, 1, 2, 3]).
% dwukrotnie(X, [3, 2, 4, 1, 2, 3]).