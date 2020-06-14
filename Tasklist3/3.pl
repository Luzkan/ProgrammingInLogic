% So we get a list of even/odd permutations of N elements.

% Every _ODD_  permutation of [n+1] elements MUST be either:
%		even permutation of N elements + [n+1] element inserted at even position	[1]
%		odd  permutation of N elements + [n+1] element inserted at odd  position	[2]
%
% Every _EVEN_ permutation of [n+1] elements MUST be either:
%		even permutation of N elements + [n+1] element inserted at odd  position	[3]
%		odd  permutation of N elements + [n+1] element inserted at even position	[4]

% Insertion of an element at an _ODD_  position represents		[5]
% 	 an even number of swaps relative to the original list.
% 	 
% Insertion of an element at an _EVEN_ position represents		[6]
% 	 an odd  number of swaps relative to the original list.
% 	 
% Disclaimer: Front of the list requires no swaps -> even.

even_permutation([], []).					% Even Permutation (empty)

even_permutation([H | T], X) :-				% [3] X = Permutation[N+1]
    even_permutation(T, Perm),
    insert_odd(H, Perm, X).
even_permutation([H | T], X) :-				% [4] X = Permutation[N+1]
    odd_permutation(T, Perm),
    insert_even(H, Perm, X).

odd_permutation([H | T], X) :-				% [1] X = Permutation[N+1]
    even_permutation(T, Perm),
    insert_even(H, Perm, X).
odd_permutation([H | T], X) :-				% [2] X = Permutation[N+1]
    odd_permutation(T, Perm),
    insert_odd(H, Perm, X).

insert_odd(X, In, [X | In]).				% [5]	 Ex: insert_odd(Y, [1, 2], X)
insert_odd(X, [Y, Z | In], [Y, Z | Out]) :-	%			X = [Y, 1, 2]
    insert_odd(X, In, Out).					%			X = [1, 2, Y]

insert_even(X, [Y | In], [Y, X | In]).		% [6]
insert_even(X, [Y, Z |In], [Y, Z | Out]) :-
    insert_even(X, In, Out).