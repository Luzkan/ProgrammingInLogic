% Odcinek - (
%			 L = [list as output of 16 variable elements in range {0, 1}]
%		   )
% Notice #1: 1 can only exist with neighbouring 1, rest of the array is 0
% Notice #2: There must be eight 1's and eight 0's
%
% Examples:
%  ?- odcinek(X).
%  X = [_11942, _11948, _11954, _11960, _11966, _11972, _11978, _11984, _11990|...],
%  tutaj pojawia się informacja o dziedzinach i ograniczeniach
%
%  ?- odcinek(X), label(X), writeln(X), fail.
%  [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1]
%  [0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0]
%  [0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0]
%  [0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0]
%  [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0]
%  [0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0]
%  [0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0]
%  [0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0]
%  [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0]
%  false.



                                    % ===== https://www.swi-prolog.org/pldoc/man?section=clpfd
:- use_module(library(clpfd)).      %       Needed for the domain (ins) and distinct ints evaluation (#\=)


% Trying to think of it like of a room with 16 walls
% 	where walls have two colors
%   and walls with same color must be near each other
%   
%	OR: Place with 8 white flowers and picking a single spot to plant 8 blue flowers
%   etc.

% -----------------------------
% Answer Version A:
%    - Eight places near each other must sum up to 8 AND total sum must be 8
odcinek(X) :-     
	length(X, 16),	
   	X = [E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16],
	S1 = [E1, E2, E3, E4, E5, E6, E7, E8],
    S2 = [E2, E3, E4, E5, E6, E7, E8, E9],
	S3 = [E3, E4, E5, E6, E7, E8, E9, E10],
    S4 = [E4, E5, E6, E7, E8, E9, E10, E11],
    S5 = [E5, E6, E7, E8, E9, E10, E11, E12],
    S6 = [E6, E7, E8, E9, E10, E11, E12, E13],
    S7 = [E7, E8, E9, E10, E11, E12, E13, E14],
    S8 = [E8, E9, E10, E11, E12, E13, E14, E15],
	S9 = [E9, E10, E11, E12, E13, E14, E15, E16],
	X ins 0..1,									
	sum(X, #=, 8),
    (
    sum(S1, #=, 8);
    sum(S2, #=, 8);
	sum(S3, #=, 8);
    sum(S4, #=, 8);
    sum(S5, #=, 8);
    sum(S6, #=, 8);
    sum(S7, #=, 8);
    sum(S8, #=, 8);
    sum(S9, #=, 8)
    ).

% -----------------------------
% Other Solutions (did out of intriguity) are in 3_other.pl, altough only Version B is finished and working, which I'm leaving here.

% -----------------------------
% Answer Version B:
%     Must have Sequence of eight 1's.
has_seq([1,1,1,1,1,1,1,1|_]).
has_seq([_|T]) :- has_seq(T).

odcinekB(B) :-     
	length(B, 16),  % Array must be length = 16
	B ins 0..1,		% They are either 0 or 1										
	sum(B, #=, 8),	% Sum of L must be equal to eight.
	has_seq(B).		% Must have a sequence of eight 1's.


% -----------------------------
% Answer Version C:
%     There can only be (UP TO exacly once) be something else than "1" after "1"
%     dev: unfinished

% -----------------------------
% Answer Version D:
%     Create a list of 9 that sums up to 8
%	      that will give list with only one element "0" 
%	  Switch (negate) 1 to 0 and 0 to 1
%	  Replace the only one existing "1" with 8x Ones 
%     dev: unfinished
