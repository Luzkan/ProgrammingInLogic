
% === I/O Functions ===
input(CMD) :- write('command: '), read(CMD).
output(Term) :- write(Term), write('\n').
inout(Term, CMD) :- output(Term), input(CMD).

% === Browsing ===
walk_print(Term, Path) :-					
	inout(Term, CMD),								% Prints Current Node and Waits for next commands
	exec(CMD, Term, Path).							% Executes Recursivelly 

browse(Term) :- walk_print(Term, []).
	
% === Traversing ===
% Path 	  	  -> Nodes in Tree Struct
% Path[P | _] -> Head as Parent of current node

% In
exec('i', Term, Path) :-
	Term =.. [_, C | _],							% Skip [Functor/Head/Parent] and get its first child
	!,
	append([Term], Path, PathAsChild),				% Concatenate it with path that was relative to parent 
	walk_print(C, PathAsChild).						% Print Term and update relative path

exec('i', Term, Path) :- walk_print(Term, Path).	% If that was not possible, just print itself

% Out
exec('o', Term, []) :- output(Term).				% Leaves the loop if its head of the tree
exec('o', _, [P | Path]) :- walk_print(P, Path).	% Prints out [Functor/Head/Parent] and update relative path

% Next
exec('n', Term, []) :- walk_print(Term, []).		% Just print itself if there's nowhere to go
exec('n', Term, [P | Path]) :-
	P =.. [_ | C],									% Skip [Functor/Head/Parent], get [Arguments/Tail/Childrens]
	append(_, [Term | []], C),						% Update relative path to be one further to the side (notice: soon to be empty)
	!,
	walk_print(Term, [P | Path]).					% Print and Update with relative path

exec('n', Term, [P | Path]) :-
	P =.. [_ | C],									% Skip [Functor/Head/Parent], get [Arguments/Tail/Childrens]
	append(_, [Term | SPR], C),						% Update relative path to be one further to the side (notice: SiblingPathRight)
	SPR = [S | _],									% Assert sibling is second
	walk_print(S, [P | Path]).						% Print right Sibling and update relative Path

% Previous
exec('p', Term, [P | Path]) :-
	P =.. [_ | C],									% Skip [Functor/Head/Parent], get [Arguments/Tail/Childrens]
	C = [Term | _],									% Skip Parent, get Tail (Childrens of Parent)
	!,
	walk_print(Term, [P | Path]).					% Print left Sibling and Update with relative path

exec('p', Term, [P | Path]) :-
	P =.. [_ | C],									% Skip [Functor/Head/Parent], get [Arguments/Tail/Childrens]
	append(SPL, [Term | _], C),						% Update relative path to be one to the left (notice: SiblingPathLeft)
	append(_, [S], SPL),							% Assert
	walk_print(S, [P | Path]).						% Print left Sibling and update Path
