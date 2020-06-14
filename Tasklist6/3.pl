% Examples:
%	- a^n, b^n:
%		> phrase(anbn, [a, a, b, b]).
%	- a^n, b^n, c^n:
%		> phrase(anbncn, [a, a, b, b, c, c]).
%	- a^n, b^{fib(n)}:
%		> phrase(anbfibn, [a, a, a, a, b, b, b, b, b]).

% Accept: a^n b^n
anbn --> [].					% Accept Empty
anbn --> [a], anbn, [b].			% Accept []

% Accept: a^n b^n c^n
% (notice: you can write prolog inside of curly brackets {})
anbncn --> {natural(N)}, a(N), b(N), c(N).
a(0) --> {!}, [].
a(N) --> {DN is N - 1}, [a], a(DN).
b(0) --> {!}, [].
b(N) --> {DN is N - 1}, [b], b(DN).
c(0) --> {!}, [].
c(N) --> {DN is N - 1}, [c], c(DN).

natural(0).
natural(N) :- natural(M), N is M + 1.

% Accept: a^n b^{fib(n)}
anbfibn --> {natural(N), fib(N, F)}, a(N), b(F).

fib(0, 1) :- !.
fib(1, 1) :- !.
fib(N, Res) :-
	N1 is N - 1,
	N2 is N - 2,
	fib(N1, Res1),
	fib(N2, Res2),
	Res is Res1 + Res2.

% Defined:
% 	p([]) −−> [].
% 	p([X | Xs]) −−>
%		[X],
%		p(Xs).
% Q: What is the relationship between L1, L2 and L3
%	 if they satisfy: phrase(p(L1), L2, L3)
%
% A: 1. if L1 > L2 -> false
%	 2. L1[N] == L2[N], for [0, 1, .., N]
%	 3. L2 - L1 = L3
