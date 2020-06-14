%   + ---1--- + ---2--- + ---3--- + 
%   |         |         |         |
%   4    a    5    b    6    c    7
%   |         |         |         |
%   + ---8--- W ---9--- X --10--- +
%   |         |         |         | 
%   11   d    12   e    13   f    14
%   |         |         |         |
%   + --15--- Y --16--- Z --17--- +
%   |         |         |         |
%   18   g    19   h    20  i     21
%   |         |         |         |
%   + --22--- + --23--- + --24--- +

matches([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]).

small([1,4,5,8]).                   % a
small([2,5,6,9]).                   % b
small([3,6,7,10]).                  % c
small([8,11,12,15]).                % d
small([9,12,13,16]).                % e
small([10,13,14,17]).               % f
small([15,18,19,22]).               % g
small([16,19,20,23]).               % h
small([17,20,21,24]).               % i
medium([1,2,4,6,11,13,15,16]).      % W
medium([2,3,5,7,12,14,16,17]).      % X
medium([8,9,11,13,18,20,22,23]).    % Y
medium([9,10,12,14,19,21,23,24]).   % Z
big([1,2,3,4,7,11,14,18,21,22,23,24]).

% === Drawing ===
% Get a List of All Matches
draw_square(L) :-
	matches(All),
	draw_square(L, All).

% Pop them and draw depending on list
draw_square(L, All) :-
	All = [X | R],
	member(X, L),
	draw_match(X),
	draw_square(L, R).
draw_square(_, []).
draw_square(L, All) :-
	All = [X | R],
	\+ member(X, L),
	draw_blank(X),
	draw_square(L, R).
	
% Space Inner Side
draw_blank(X) :-
	member(X, [1,2,8,9,15,16,22,23]),
	write('+...').
% Space Inner Between
draw_blank(X) :-
	member(X, [3,10,17,24]),
    write('+....+'),
    nl.
% Space Inner Between Empty
draw_blank(X) :-
	member(X, [4,5,6,11,12,13,18,19,20]),
	write(' .....').
% Space Inner Side Right
draw_blank(X) :-
	member(X, [7,14,21]),
    write('.'), 
    nl.

% Match Point Side Left
draw_match(X) :-
	member(X, [1,2,8,9,15,16,22,23]),
	write('+---').
% Match Point Between
draw_match(X) :-
	member(X, [3,10,17,24]),
    write('+---+'),
    nl.
% Match Point Inner
draw_match(X) :-
	member(X, [4,5,6,11,12,13,18,19,20]),
	write('|.....').
% Match Point Side Right
draw_match(X) :-
	member(X, [7,14,21]),
    write('|'),
    nl.

% === Definitions and Getters ===

q_small(L, Sm) :-     	% Querry to get based on L
	small(Sm),        	% array represting small square
	subset(Sm, L).    	% made of subset of L
q_medium(L, Md) :-  
    medium(Md),
    subset(Md, L).

% Returns answer if num of answers equal to N (test)
t_small(L, Answ, N) :- 	
    aggregate_all(count, q_small(L, Answ), N),
    q_small(L, Answ).
t_medium(L, Answ, N) :-
    aggregate_all(count, q_medium(L, Answ), N),
    q_medium(L, Answ).

% Returns all answers in a list from t_ funcs (get)
g_small(L, SmallArr, N) :-		
    bagof(Answ, t_small(L, Answ, N), SmallArr).
g_medium(L, MediumArr, N) :-	
    bagof(Answ, t_medium(L, Answ, N), MediumArr).

% Boolean check if big is included (bool)
b_big(L, 1) :-
	big(Duzy),
    subset(Duzy, L),
    !.
b_big(L, 0) :-
	big(Duzy),
	\+ subset(Duzy, L).

% === Analyzing ===
% True if (Length, List1, Sub_Of_List1) is
%   List2 is subset of List1 of length Length
subset_length(0, [], []).
subset_length(Len, [E|Tail], [E|NTail]):-
	PLen is Len - 1,
	(PLen > 0 -> subset_length(PLen, Tail, NTail) ; NTail=[]).
subset_length(Len, [_|Tail], NTail):-
	subset_length(Len, Tail, NTail).

% True if (List, Element) is
%   Elements of List consist of elements of Elements
includes(L, E) :-
	includes(L, [], E).
includes(L, Es, E) :-
	E = [M | R],
	append(M, Es, Ex),
    includes(L, Ex, R),
    !.
includes(L, Es, []) :-
	L = Es.
	
% List, Leftover Matches, TrueForBig, Num Small Square, Num Medium Square
square(L, N, 1, S, M) :-
	matches(All),                       % All is a set of all matches
	g_small(All, ASmall, _),            % Get all possible combinations of small squares
	g_medium(All, AMedium, _),          % Get all possible combinations of medium squares
	big(LBig),                          % Retrieve big square pattern
	subset_length(M, ASmall, Small),    % Get all permutations of length M of small squares
	subset_length(S, AMedium, Medium),  % Get all permutations of length S of medium squares
	includes(LSmall, Small),            % True if elements of LSmall exist in Small
	includes(LMedium, Medium),          % True if elements of LSmall exist in Small
	union(LBig, LMedium, LBigMed),      % Merge answers
	union(LSmall, LBigMed, LBigMedSml),
	sort(LBigMedSml, L),                % Sort answers
	length(L, N),                       % Check Total Length
	g_small(L, _, M),                   % Check Small Sized Length
	g_medium(L, _, S),                  % Check Medium Sized Length
	b_big(L, 1),                        % Assert Big True
	draw_square(L).                     % Call Drawing
	
square(L, N, 0, S, M) :-
	matches(All),                       % Same as above, but Asserting Big False
	g_small(All, ASmall, _),
    g_medium(All, AMedium, _),
    big(LBig),
	subset_length(M, ASmall, Small),
	subset_length(S, AMedium, Medium),
	includes(LSmall, Small),
	includes(LMedium, Medium),
	union(LMedium, LSmall, LMedSml),
	sort(LMedSml, L),
	length(L, N),
	g_small(L, _, M),
	g_medium(L, _, S),
	\+ subset(LBig, L),
	draw_square(L).

% === Main ===
zapalki(N, (duze(D), srednie(S), male(M))) :-
	AM is 24-N,
	square(_, AM, D, S, M).
zapalki(N, (srednie(S), male(M))) :-
	AM is 24-N,
	square(_, AM, 0, S, M).
zapalki(N, (duze(D), male(M))) :-
	square(_, AM, D, 0, M),
	N is 24 - AM.
zapalki(N, (duze(D), srednie(S))) :-
	AM is 24-N,
	square(_, AM, D, S, 0).
zapalki(N, (duze(D))) :-
	AM is 24-N,
	square(_, AM, D, 0, 0).
zapalki(N, (srednie(S))) :-
	AM is 24-N,
	square(_, AM, 0, S, 0).
zapalki(N, (male(M))) :-
	AM is 24-N,
	square(_, AM, 0, 0, M).