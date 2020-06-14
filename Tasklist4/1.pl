rule(Answer, LArg, RArg) :-
    Answer = LArg + RArg.
rule(Answer, LArg, RArg) :-
    Answer = LArg - RArg.
rule(Answer, LArg, RArg) :-
    Answer = LArg * RArg.
rule(Answer, LArg, RArg) :-
    Answer = LArg / RArg,
    RArg =\= 0.

generate([OneElement], OneElement).		% Get the element from array with only that element
generate(L, Answer) :-
	append(L1, L2, L),				    % In the TaskList the example results keeps the list of equations in order
    								    %	so we can take use of append to create sublist L1 out of L without L2
    								    % 	otherwise can use permutations(   ) to achieve all possible combinations
    								    % 	out of the given list.
	\+ length(L1, 0),				    % We don't want lists of length zero as we would enter
	\+ length(L2, 0),				    % 	infinite loop recursing this function
	generate(L1, LArg),				    % We break the list into pieces of size 1 (because ^)
	generate(L2, RArg),			
	rule(Answer, LArg, RArg).		    % And now we return all possible rules

wyrazenie(List, LookFor, Equation) :-
	generate(List, Answer),
	LookFor is Answer,				    % Out of the whole world of equations, we get only those that evalue to
    								    % 	what we've been looking for...
	Equation = Answer.				    % ... and return it in the "equation".
