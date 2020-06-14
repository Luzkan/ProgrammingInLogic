% Marcel Jerzyk 244979
le(1, 2).
le(1, 3).
le(1, 5).
le(1, 7).
le(1, 11).
le(2, 4).
le(2, 6).
le(3, 6).
le(3, 9).
le(5, 10).
le(4, 12).
le(4, 8).
le(6, 12).

% le(a, c).
% le(b, c).
% le(a, d).
% le(b, e).
% le(d, f).
% le(e, f).

% Is max if it's on the right side and it's NOT true that
%				there exist some Y that it's not equal to our X
%				and it is higher than our X
max(X) :-
	le(_, X),
	\+ 	(
	    	le(_, Y),
	    	X \= Y,
	    	le(X, Y)
		).

% Min reversed 
min(X):-
	le(X, _),
	\+ 	(
	    	le(Y, _),
	    	X \= Y,
	    	le(Y, X)
		).

% Biggest if there is only one max in the relation tree (max(X) will list 4 answers, so there's none).
biggest(X) :-
    max(X),
    \+ 	(
        	max(Y), X \= Y
        ).

% Least reversed (min(X) will list only "1" as an answers, so that's the least element).
least(X) :-
 	min(X),
	\+ 	(
        	min(Y), Y \= X
        ).


/**
 * Console cmds:
 * max(X).
 * min(3).
 * min(1).
 * least(12).
 * least(1).
 * biggest(12).
 * biggest(X).
**/