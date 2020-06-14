% Kolorowanie(X)
% Notice: Using three colors + none of neighboring areas can share same color
% Examples:
%  ?- kolorowanie(X).
%  X = [_7942, _7948, _7954, _7960, _7966, _7972, _7978, _7984, _7990],
%  % ... areas and restrictions informations
%  ?- kolorowanie(X), label(X).
%  X = [1, 2, 1, 3, 2, 3, 1, 2, 3] ;
%  X = [1, 3, 1, 2, 3, 2, 1, 3, 2] ;
%  X = [2, 1, 2, 3, 1, 3, 2, 1, 3] ;
%  X = [2, 3, 2, 1, 3, 1, 2, 3, 1] ;
%  X = [3, 1, 3, 2, 1, 2, 3, 1, 2] ;
%  X = [3, 2, 3, 1, 2, 1, 3, 2, 1].


%								  Map
%   _________________________________________________________________
%  |                         |										 |
%  |           R1            |______________			 R6	         |
%  |                         |              |                        |
%  |_________________________|              |_____________           |
%  |               |    |                   |	          |          |
%  |           ____| R4 |         R5        |      R7     |      ____|
%  |		  |    |    |                   |             |     |    |
%  |          |    |____|___________________|      _______|_____|    |
%  |    R2    |      R3        |      |           |                  |
%  |		  |________________|      |___________|____              |
%  |					|							   |     R8      |
%  |					|			   R9	     	   |             |
%  |____________________|______________________________|_____________|

%				 Neighbours:
%
%		R1	R2	R3	R4	R5	R6	R7	R8	R9			
%  R1   --  XX		XX	XX	XX
%  R2	    --  XX	XX					XX			% We are interested only in the neighbours
%  R3		    --	XX	XX				XX			% Above the diagonal line
%  R4				--	XX							%
%  R5					--	XX	XX		XX			% Below it we would list duplicates
%  R6						--  XX	XX				% Which is not necessery
%  R7							--	XX	XX
%  R8								--	XX
%  R9									--

													% ===== https://www.swi-prolog.org/pldoc/man?section=clpfd
:- use_module(library(clpfd)).						%       Needed for the domain (ins) and distinct ints evaluation (#\=)

% Three Color Problem
kolorowanie(X) :-									
	X = [R1, R2, R3, R4, R5, R6, R7, R8, R9],		% Declaring Areas as an Array
													%		Quick look how the areas are placed on the map above
	X ins 1..3,										% Each of the Area element in Areas must be element of domain
													%       All Integers I such that 1 =< I <= 3 (our colors)
	R1 #\= R2, R1 #\= R4, R1 #\= R5, R1 #\= R6,		% Using above neighbours matrix just write down distinct evals
	R2 #\= R3, R2 #\= R4, R2 #\= R9,
	R3 #\= R4, R3 #\= R5, R3 #\= R9,
	R4 #\= R5,
	R5 #\= R6, R5 #\= R7, R5 #\= R9,
	R6 #\= R7, R6 #\= R8,
	R7 #\= R8, R7 #\= R9,
	R8 #\= R9.