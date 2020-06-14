arc(a, b).
arc(b, a).
arc(b, c).
arc(c, d).

ścieżka(X, Y, _) :- 
    arc(X, Y).

ścieżka(X, Y, R) :-
	arc(X, Z),
	\+	member(Z, R),
	ścieżka(Z, Y, [Z | R]).

osiągalny(X, X).
osiągalny(X, Y) :- 
    ścieżka(X, Y, [X]),
    X \= Y.

% ścieżka(a, c, [a]).
% osiągalny(a, X).
% osiągalny(b, X).
% osiągalny(c, X).
% % ścieżka(d, X, [d]).
% osiągalny(d, X).
% osiągalny(X, a).