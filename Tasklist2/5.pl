% For: X is 2*N
is_double(X, Y) :-
    Z is X*2,
    length(Y, Z).

% ______________________________
% For: Elements exist twice in the array
once(X, L) :-
    select(X, L, L1),
    \+ member(X, L1).

twice(X, L) :- 
    select(X, L, L1),
	once(X, L1).

% ______________________________
% For: Checking if the space is even
is_even(X) :-
    Y is X//2,
    X =:= 2 * Y.

% ______________________________
% For: Elements from 1 to N (works from N to 1)
loop_to(0, _).
loop_to(N, L) :-					% We'll check every number from N to 1
    N > 0,							%
    twice(N, L),					% First, let's see if this number exist only twice in our array
    sum_indexes(N, L, _),			% Now, I'll sum the indexes. If they are correct, they should give odd number
    								% That odd number means that there are even number of elements between them
    								% Added one in previous stem to my idx sum and i'm checking if that's correct
    M is N-1,						% Everything is correct for that n
    loop_to(M, L).					% Let's go to the next one

% ______________________________
% For: Counting space between two X elements in array
% Disclaimer: I just want to know if the space is even.
% 	So I don't need to subtrack place_x2 from place_x1
% 	I can just add them up, and it'll give the same result.

sum_indexes(E, L, V) :-
    findall(P, nth0(P, L, E), LP),
    (	
    	LP = [] -> false;
    	sum_list(LP, V)
    ),
    is_even(V+1).

% ______________________________
% I spend a lot of time on this task, but I think I didn't understood it perfectly
% So I created few options to get different answers just in case
% Like - list will print:
% 	absolutelly all possible combinations
%	absolutelly all starting points
%	absolutelly all possible name-pinning to the crossroads
% Listfirst will print:
% 	all crossroads with given starting point Z
% 	all possible name-pinning to the crossroads
% listall will print:
%	same as list, but with tons of duplicates

listfirst(N, X, Z) :-
    list(N, X),
    X = [H | _],
    H = Z.

list(N, X) :-
	distinct(listall(N,X)).

listall(N, X) :-
    is_double(N, X),		% Make sure list is twice as long as N
	pred(N, L1),			% Create a list of numbers from 1 to N
    pred(N, L2),			% and a second one
	append(L1, L2, Res),	% Concatenate them
	perm(Res, X),			% Create all possible permutations of those two concatenated lists
	testlist(N, X).

% Test if it meets the requirements
testlist(N, X) :-
    is_double(N, X),
    loop_to(N, X).
  	  
% ______________________________
% For: Creating a list from N to 1
pred(1, [1]).
pred(N, [N|T]) :-
    N > 1,
    N1 is N-1,
    pred(N1, T).
  
% ______________________________
% For: Creating all possible permutations of a list
takeout(X, [X|R], R).  
takeout(X, [F|R], [F|S]) :-
    takeout(X,R,S).

perm([X|Y],Z) :-
    perm(Y,W),
    takeout(X,Z,W).  
perm([],[]).

% ______________________________
% ______________________________
% ______________________________
% NOT USED STUFF, MAYBE FOR FUTURE STUFF:
% Fills a list
fill([], _, 0).
fill([X|Xs], X, N) :-
    succ(N0, N),
    fill(Xs, X, N0).
