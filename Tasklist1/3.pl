% Marcel Jerzyk 244979
left_of(aparat, bicycle).
left_of(fish, butterfly).
left_of(butterfly, hourglass).
left_of(hourglass, pencil).
above(butterfly, aparat).
above(pencil, bicycle).

right_of(X, Y) :- left_of(Y, X).
below(X, Y) :- above(Y, X).

% ThingX is on left side of ThingY if
%		[ThingX is on the left of some ThingZ AND try to find if that ThingZ
%		 is on the left of another thingZ_2 until it is on the left of ThingY]
%		or
%		[ThingX is on the left of ThingY]
left_of_rec(X, Y) :-
    (
	    left_of(X, Z),
	    left_of_rec(Z, Y)
	);
    left_of(X, Y).

% Same for things above
above_rec(X, Y) :-
	(
	    above(X, Z),
	    above_rec(Z, Y)
	);
	above(X, Y).

% It can be directly above, or something on left/right has it somewhere above
higher(X, Y) :-
    above_rec(X, Y);
    (   
    	above_rec(Z, Y),
        (   
    		left_of_rec(X, Z);
    		right_of_rec(X, Z)
        )
    ).
        

/**
 * % Console cmds:
 * left_of_rec(fish, pencil).
 * right_of_rec(hourglass, fish).
 * higher(hourglass, bicycle).
 * higher(aparat, bicycle).
 * higher(fish, bicycle).
 * higher(bicycle, fish).
**/