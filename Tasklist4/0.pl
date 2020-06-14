hetmans(N, P) :-
    numlist(1, N, L), 			% False if N < 1.
    permutation(L, P),			% All permutations of list L as P
    good(P).					% Test if that P is good...

good(P) :-
    \+ bad(P).					% ... where good means not bad

bad(P) :-
    append(_, [Wi | L1], P),	% Gets in sequence the first element in Wi and rest of the list until empty 
    append(L2, [Wj | _], L1),	% Gets in sequence first element and then puts into the L2 list continously (until Wj is last element of L1)
    length(L2, K),				% Returns length of above created L2
    abs(Wi - Wj) =:= K + 1.		% Compare that length to Wi (which is always one current head element just like Wj) - Wj
