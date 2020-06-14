pm(+).
pm(-).

% Sub/Add with Zero
rule(LArg, Op, 0, LArg) :-
    number(LArg),
	pm(Op).
rule(0, +, RArg, RArg) :-
    number(RArg).

% Sub Self
rule(LArg, -, RArg, 0) :-
    LArg = RArg.

% Times Zero
rule(0, *, _, 0).
rule(_, *, 0, 0).

% Times One
rule(Arg, *, 1, Arg).
rule(1, *, Arg, Arg).

% Divide One
rule(Arg, /, 1, Arg).

% Divide Self
rule(LArg, /, RArg, 1) :-
	LArg = RArg,
    RArg =\= 0.

% Stack
rule(Arg1*Arg2, /, Arg1, Arg2) :-
	number(Arg2),
	Arg1 =\= 0.
rule(Arg1*Arg2, /, Arg2, Arg1) :-
	\+ number(Arg1).
rule(Arg1*Arg2, /, Arg2, Arg1) :-
	number(Arg1),
	Arg2 =\= 0.
rule(Arg1*Arg2, /, Arg2, Arg1) :-
	\+ number(Arg2).
		
% First Case with Recursive Calling
% when: We don't have a rule that solves Equation instantly
simplify(E, Res) :-				% equation: a*(b*c/c-b)", result: X
	E =.. O,					% Create a structure out of equation 		O = [(*), a, b*c/c-b]
	O = [Op | _],				% Get Head of the structure above 			Op = (*)
	select(Op, O, L), 			% Getting first Argument					L = [a, b*c/c-b]
	L = [LArg | _],				% Get Head 									LArg = a
	select(LArg, L, R),			% Getting second Argument					R = [b*c/c-b]
	R = [RArg | _],				% Get Head									Rarg = b*c/c-b
	\+ rule(LArg, Op, RArg, _), % Should be not possible to solve RArg in this form
	simplify(LArg, LArgF),		% Recursive Left Call						LArg = LArgF = a
	simplify(RArg, RArgF),		% Recursive Right Call						RArg = b*c/c-b    | RArgF = 0
	rule(LArgF, Op, RArgF, Res).% Finish ruling 							rule(a, *, 0, Res) -> Res = 0 
	
% Second Case w/o Recursive Calling
% when: There's a rule that solves it.
simplify(E, Res) :-				% equation: "E = a*1",  result: "R = X"
	E =.. O,					% Create a structure out of equation 		O = [(/), a, 1],
	O = [Op | _],				% Get Head of the structure above 			Op = (/)
	select(Op, O, L), 			% Getting first Argument					L =  [a, 1]
	L = [LArg | _],				% Get Head 									LArg = a
	select(LArg, L, R),			% Getting second Argument					R = [1]
	R = [RArg | _],				% Get Head									Rarg = 1
	rule(LArg, Op, RArg, Res).	% Finish ruling								rule(a, /, 1, Res) -> Res = a

% Third Case 
% when: There are no operators <-> Equations is the Result
simplify(E, Res) :-				% 
    E = Res,
	E =.. L,					
	L = [_ | []].