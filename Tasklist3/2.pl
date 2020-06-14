% Find Local Maximum (we had such task on previous course Alghorithms & Data Structures, cool!)
% So the idea is to traverse the list once:
%	Calculate current local maximum
%	Check if it's bigger than zero
%		If it is, maybe we can build on that in the next iteration
%		If it's not - abandon it and count again from 0
%	Always save the biggest spotted number so far

max_sum(L, S) :-
    max_sum(L, S, 0, 0).
 
 max_sum([], S, _, MT) :-
     S is MT.
 
 max_sum([H | T], S, ML, MT) :-
     MLI is max(0, ML + H),		% Check if it makes sense to continue searching for local maximum
     MTI is max(ML, MT),			% Save the maximum we found so far
     max_sum(T, S, MLI, MTI).	% Recursive call on tail
 