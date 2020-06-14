wykonaj(NazwaPliku) :- execute(NazwaPliku).

execute(Filename) :-
	open(Filename, read, X),
	scanner(X, Y),
	close(X),
	phrase(program(PROGRAM), Y),
	interpreter(PROGRAM).

interpreter(PROGRAM) :-
    interpreter(PROGRAM, []).

interpreter([], _).
interpreter([read(ID) | INSTRUCTIONS], ASSOC) :-
	!,
    read(N),
    integer(N),
    put(ASSOC, ID, N, ASSOC1),
    interpreter(INSTRUCTIONS, ASSOC1).

interpreter([write(W) | INSTRUCTIONS], ASSOC) :-
	!,
    value(W, ASSOC, WART),
    write(WART), nl,
    interpreter(INSTRUCTIONS, ASSOC).

interpreter([assign(ID, W) | INSTRUCTIONS], ASSOC) :-
	!,
    value(W, ASSOC, VAL),
    put(ASSOC, ID, VAL, ASSOC1),
    interpreter(INSTRUCTIONS, ASSOC1).

interpreter([if(C, P) | INSTRUCTIONS], ASSOC) :-
	!,
    interpreter([if(C, P, []) | INSTRUCTIONS], ASSOC).

interpreter([if(C, P1, P2) | INSTRUCTIONS], ASSOC) :-
	!,
    (
		evaluate(C, ASSOC) ->
			append(P1, INSTRUCTIONS, PASS);
		   	append(P2, INSTRUCTIONS, PASS)
	),
    interpreter(PASS, ASSOC).

interpreter([while(C, P) | INSTRUCTIONS], ASSOC) :-
	!,
    append(P, [while(C, P)], PASS),
    interpreter([if(C, PASS) | INSTRUCTIONS], ASSOC).

put([], ID, N, [ID = N]).
put([ID = _ | ASSOC], ID, N, [ID = N | ASSOC]) :- !.
put([ID1 = W1 | ASSOC1], ID, N, [ID1 = W1 | ASOC2]) :-
    put(ASSOC1, ID, N, ASOC2).

take([ID = N | _], ID, N) :- !.
take([_ | ASSOC], ID, N) :-
    take(ASSOC, ID, N).

value(int(N), _, N).
value(id(ID), ASSOC, N) :-
    take(ASSOC, ID, N).

value(W1+W2, ASSOC, N) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N is N1+N2.

value(W1-W2, ASSOC, N) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N is N1-N2.

value(W1*W2, ASSOC, N) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N is N1*N2.

value(W1/W2, ASSOC, N) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N2 =\= 0,
    N is N1 div N2.

value(W1 mod W2, ASSOC, N) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N2 =\= 0,
    N is N1 mod N2.

evaluate(W1 =:= W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 =:= N2.

evaluate(W1 =\= W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 =\= N2.

evaluate(W1 < W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 < N2.

evaluate(W1 > W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 > N2.

evaluate(W1 >= W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 >= N2.

evaluate(W1 =< W2, ASSOC) :-
    value(W1, ASSOC, N1),
    value(W2, ASSOC, N2),
    N1 =< N2.

evaluate((W1, W2), ASSOC) :-
    evaluate(W1, ASSOC),
    evaluate(W2, ASSOC).

evaluate((W1; W2), ASSOC) :-
    (
		evaluate(W1, ASSOC),
		!;
		evaluate(W2, ASSOC)
	).