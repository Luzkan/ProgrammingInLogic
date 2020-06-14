% Gets a List (preferably use Hetman...) and displays it visually
board(L) :-	
	length(L, Length),							% Gets length of given list
	(
		even_number(Length) ->					% Depending on parity of length we decide color			
			draw(L, Length, white, Length);		% If even: white
			draw(L, Length, black, Length)		% Else odd: black
	), !.
	
% === Board Drawing ===
% Handles drawing from top to bottom, in chunks (blocks), starts with Color
draw(_, N, _, 0) :- e(N).
draw(L, N, Color, Row) :-
	draw_block_e(N),							% Commands drawing full edge of a block	+-----+-----+-----+ 
	draw_block_in(L, N, Color, Row, 1),			% Commands drawing inside of a block	+:::::+     +:::::+
	draw_block_in(L, N, Color, Row, 1),			% Commands drawing inside of a block	+:::::+     +:::::+
	NextRow is Row - 1,							% Decrease counter to get next row on next iteration
	(
		Color = white ->						% Swaps the current color
			SwapColor = black;					% If was white, now start with black 
			SwapColor = white					% Else was black, now start with white 
	),
	draw(L, N, SwapColor, NextRow).
	
% === Draws Blocks Insides ===
draw_block_in(L, N, Color, Row, 1) :-			% Draws insides of a block
	in_handle(L, N, Color, Row, 1),				% Executes
	write('\n').								% Proceeds to next line

% Check if it's the last block - draw with right edge
in_handle(L, N, Color, Row, N) :- in(L, N, Color, Row, N).				
in_handle(L, N, Color, Row, Col) :-
	in(L, N, Color, Row, Col),					% Draw one inside row of a block
	NextCol is Col + 1,							% Increase counter to get next column on next iteration
	(
		Color = white ->						% Swaps the current color for next block
			SwapColor = black;					% If was white, now start with black 
			SwapColor = white					% Else was black, now start with white 
	),
	L = [_ | Next],
	in_handle(Next, N, SwapColor, Row, NextCol).
	
in(L, N, Color, Row, Column) :-
	(
		Color = white ->						% Depending on Color
			(									% Run White Drawing
				het_in(L, Row, Column) ->		% Check for Hetman Block
					write('| ### ');			% If True: print him
					write('|     ')				% Else: not
			);					
			(									% Run Black Drawing
				het_in(L, Row, Column) ->		% Check for Hetman Block
					write('|:###:');			% If True: print him
					write('|:::::')				% Else: not
			)						
	),
	(											
		Column = N ->							% Check if that's last column
			write('|');							% If True: add right edge
			write('')							% Else: nothing
	), !.

% === Draws Blocks Edge ===
draw_block_e(N) :-								% Draws top edge of a block
	e(N),										% Executes
	write('\n').								% Proceeds to next line

e(1) :- write('+-----+').						% [->1] until it's final block of the board
e(N) :-						
	write('+-----'),							% Draws an edge of one block
	ND is N - 1,								% Decrease Counter
	e(ND).										% Recursive call [1->]
	
% === Helping Functions ===
het_in([First | _], First, _).
even_number(0) :- !.
even_number(1) :- !, fail.
even_number(N) :- M is N - 2, even_number(M).

% === Hetman Function ===
hetmany(N, P) :- hetmans(N, P).					% Just to fit call as specified in the tasklist
hetmans(N, P) :-
	numlist(1, N, L), 							% False if N < 1.
	permutation(L, P),							% All permutations of list L as P
	good(P).									% Test if that P is good...
    
good(P) :-
	\+ bad(P).									% ... where good means not bad

bad(P) :-
	append(_, [Wi | L1], P),	        		% Gets in sequence the first element in Wi and rest of the list until empty 
	append(L2, [Wj | _], L1),	        		% Gets in sequence first element and then puts into the L2 list continously (until Wj is last element of L1)
	length(L2, K),								% Returns length of above created L2
	abs(Wi - Wj) =:= K + 1.						% Compare that length to Wi (which is always one current head element just like Wj) - Wj
