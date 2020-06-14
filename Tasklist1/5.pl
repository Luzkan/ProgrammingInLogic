% Marcel Jerzyk 244979
% Reflexivity
le(a, a).
le(b, b).
le(c, c).
le(d, d).

% Transitivity
le(a, b).
le(b, c).
le(a, c).
%uncomment to break
%le(c, d).

% Antisymmetry
%uncomment to break 
%le(b, a).

partial_order :- reflexivity, antisymmetry, transitivity.

relation(X) :-
    le(X, _);
    le(_, X).

% Reflexivity: every element is related to itself
% a ≤ a
reflexivity :-
    \+	(
        	relation(X),
            \+ le(X, X)
        ).

% Antisymmetry: two distinct elements cannot be related in both directions)
% a ≤ b and b ≤ a, then a = b
antisymmetry :-
	\+ 	(
        	relation(X),
            relation(Y),
           	le(X, Y),
            le(Y, X),
            X \= Y
       	).

% Transitivity: if a first element is related to a second element and that element
% 				is related to a third element,
% 				then the first element is related to the third element
% a ≤ b and b ≤ c, then a ≤ c
transitivity :-
	\+ 	(
          	relation(X),
            relation(Y),
            relation(Z),
            X \= Y,
            Y \= Z,
            X \= Z,
            le(X,Y),
            le(Y,Z),
            \+ le(X,Z)
        ).

/**
 * Console cmds:
 * partial_order
**/