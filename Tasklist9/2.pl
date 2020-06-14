% This task is about creating predicate 'kwadraty'
% that checks if it's possible to fit squares of
% length given in the list in a rectangle
% with given width and height.

% kwadraty(SqrList, Width, Height, Coords)
%    - SqrList:  List of squares defined by int representing length
%    - Width:    Width of the big square
%    - Height:   Height of the big square
%	 - Coords:   Coordinates of smaller squares (relative to bottom left corner)
% Examples:
%  ?- kwadraty([1,1,1,1,2,2,2,2,3,3], 7, 6, X).
%  X = [3,2,0,5,1,5,2,5,3,0,5,0,0,3,2,3,0,0,4,2]

% ===== https://www.swi-prolog.org/pldoc/man?section=clpfd
% Needed for the domain (ins) and distinct ints evaluation (#\=)
:- use_module(library(clpfd)).						


%  Example (not up to scale)
%   _______________________
%  |             |______   |
%  |             |      |  |
%  |      4      |   5  |  |
%  |             |______|__|
%  |_____________|         |
%  |      |      |    3    |
%  |   1  |   2  |         |
%  |______|______|_________|

% So let's say that we are given the big square of size 4x5
% And we were given a list [1, 1, 1, 1, 2, 3]. 
% We could fit those squares like in the axmple above:
%   1  -  1x1
%   2  -  1x1
%   3  -  2x2
%   4  -  3x3
%   5  -  1x1

% Notice that:
%   - by placing a square, first we do a check
%     if it's even possible to place it:
%     - we get it's size
%     - we get the size of big square
%     - subtrack these
%     - available x/y coords: {0, 1, ..., result}

fit([], _, _, [], []) :- !.
fit([Sqr|SqrListLeft],				% Get small square from small square list
	 Width,							% Width of the defined big square
	 Height,						% Height of the defined big square
	 [f(X, Sqr, Y, Sqr)|SqrSetd],   % Functor(X coord, Width, Y coord, Height) for disjoint2
	 [X, Y|CoordsSetd]) :-			% Coordinates that we will print out

    W #= Width - Sqr,				% Get the possible width and
    H #= Height - Sqr,				% get the possible height...
    X in 0..W,						% ... and put them into 
    Y in 0..H,						% a list of possible coords 
    fit(SqrListLeft, Width, Height, SqrSetd, CoordsSetd).

kwadraty(SqrList, Width, Height, Coords) :-
	fit(SqrList, Width, Height, Terms, Coords),
    disjoint2(Terms),				% This guarantees that given terms are disjoint in 2D
    label(Coords).					% Out