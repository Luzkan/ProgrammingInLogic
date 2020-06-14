% Phrasing Command:
% 	- Example:
%		> open('ex1.prog', read, X), scanner(X, Y), close(X), phrase(program(PROGRAM), Y).

%  ===== SCANNER ===== 
%  === List of Tokens  === 
key('read').
key('write').
key('if').
key('then').
key('else').
key('fi').
key('while').
key('do').
key('od').
key('and').
key('or').
key('mod').
sep(';').
sep('+').
sep('-').
sep('*').
sep('/').
sep('(').
sep(')').
sep('<').
sep('>').
sep('=<').
sep('>=').
sep(':=').
sep('=').
sep('/=').
sep(':').

% Functional Lexing Tokens
blank(' ').
blank('\n').
blank('\t').

% === The Scanner ===
% For New Users tl;dr on Windows:
% 	- Put file in: %users%/Documents/Prolog
% 	- Check if its okay: 
%		> "exists_file('ex1.prog')"
%	- Load it in (you have to use parenthesis as its not prolog .pl file):
%		> ['ex1.prog'] 
%	- Use with command:
% 		> scanner('ex1.prog', X) 
%	- Example:
%		> open('ex1.prog', read, X), scanner(X, Y), close(X), write(Y).
scanner(S, X) :-
	get_char(S, C),			% Get Character C from stream input S
	lexer(S, C, X),			% Starts reading, output as X
	!.

% === Read Helpers ===
% Keywords
% Character with lowercase letter (https://www.swi-prolog.org/pldoc/man?section=chartype)
word(C) :-
	string_length(C, 1),								% Check for size = 1
	char_type(C, lower), !.								% Check for char = lowercase

% Ints
% Converts between atom and number (https://www.swi-prolog.org/pldoc/doc_for?object=atom_number/2)
int('0') :- !.											% [->2] until hits 0
int(C) :-
	atom_number(C, NUp),								% To Number		
	N is NUp - 1,										% Subtrack one
	atom_number(SN, N),									% Back to String
	int(SN).											% Recusrive call [2->]
	
% Identifiers
% Character with uppercase
id(C) :-
	string_length(C, 1),								% Check for size = 1
	char_type(C, upper), !.								% Check for char = uppercase
id(ID) :-
	get_string_code(1, ID, Check),						% True when string at index ID[1] equals to Check
	char_type(Check, upper),							% Check for uppercase
	atom_concat(H, T, ID),								% Concatenation of head and trailing part as ID
	string_length(H, 1),								% Check for size = 1
	id(T), !.
	
% === Full Command Read === 
% CCurr  -> Char Currently
% CNext	 -> Char Next
% CEval  -> Char (as String) evaluation if done
% CMDAtm -> Command At This mMoment (read so far)
% CMDExp -> Command Expanded (with added char)
% Lex	 -> The identified command
% Fin	 -> Finished Identifying (passed further as Lex)
% S		 -> Input String
% SCont  -> Continuation (output)

% Keyword Handling
keyword(_, end_of_file, end_of_file, Fin, Fin) :- !.	% End if EOT
keyword(_, C, C, Fin, Fin) :- \+ word(C), !.			% End if lowercase wasn't satisfied anymore
keyword(S, CCurr, CEval, CMDAtm, Fin) :-							
	atom_concat(CMDAtm, CCurr, CMDExp),					% Concatenate CMDAtm+CCurr into CMDExp (notice: on first call CMDAtm == "")
	get_char(S, CNext),									% Gets char CNext from string S
	keyword(S, CNext, CEval, CMDExp, Fin).				% Recursive call (notice: now instead of "", arg_03 is concatenation)
	
% Numbers Handling
keynum(_, end_of_file, end_of_file, Fin, Fin) :- !.		% End if EOT
keynum(_, C, C, Fin, Fin) :- \+ int(C), !.				% End if int wasn't satisfied anymore
keynum(S, CCurr, CEval, CMDAtm, Fin) :-
	atom_concat(CMDAtm, CCurr, CMDExp),					% Concatenate CMDAtm+CCurr into CMDExp (notice: on first call CMDAtm == "")
	get_char(S, CNext),									% Gets char CNext from string S
	keynum(S, CNext, CEval, CMDExp, Fin).				% Recursive call (notice: now instead of "", arg_03 is concatenation)
	
% ID Handling
keyid(_, end_of_file, end_of_file, Fin, Fin) :- !.		% End if EOT
keyid(_, C, C, Fin, Fin) :- \+ id(C), !.				% End if id isn't satisfied anymore
keyid(S, CCurr, CEval, CMDAtm, Fin) :-
	atom_concat(CMDAtm, CCurr, CMDExp),					% Concatenate CMDAtm+CCurr into CMDExp (notice: on first call CMDAtm == "")
	get_char(S, CNext),									% Gets char CNext from string S
	keyid(S, CNext, CEval, CMDExp, Fin).				% Recursive call (notice: now instead of "", arg_03 is concatenation)
	
keysep(_, end_of_file, end_of_file, Fin, Fin) :- !.		% End if EOT
keysep(_, C, C, Fin, Fin) :- \+ sep(C), !.				% End if sep isn't satisfied anymore
keysep(S, CCurr, CEval, CMDAtm, Fin) :-
	atom_concat(CMDAtm, CCurr, CMDExp),					% Concatenate CMDAtm+CCurr into CMDExp (notice: on first call CMDAtm == "")
	get_char(S, CNext),									% Gets char CNext from string S
	keysep(S, CNext, CEval, CMDExp, Fin).				% Recursive call (notice: now instead of "", arg_03 is concatenation)


% === Reading Disposal === 
lexer(_, end_of_file, []) :- !.							% EOT, End.

% Blanks
lexer(S, CCurr, X) :-
	blank(CCurr),										% Blank works as separator between cmds
	!,													% Do not backtrack behind (the blank)
	get_char(S, CNext),									% Read next character
	lexer(S, CNext, X).									% Continue

% Keywords
lexer(S, CCurr, [E | SCont]) :-
	word(CCurr),										% Determine if it's a lowercase char of size one
	keyword(S, CCurr, CNext, '', Lex),					% Get the whole word
	!,													% Do not backtrack
	key(Lex),											% Check if the whole key is defined
	atom_concat('key(', Lex, P),						% Merge our word for display purposes as intended
	atom_concat(P, ')', E),								% Basically str = "key(" + word + ")"
	lexer(S, CNext, SCont).								% Continue

% Numbers
lexer(S, CCurr, [E | SCont]) :-
	int(CCurr),											% Determine if it's a integer
	keynum(S, CCurr, CNext, '', Lex),					% Get the whole number
	!,													% Do not backtrack
	int(Lex),											% Check if the whole number is defined (notice: we defined all numbers up to 0)
	atom_concat('int(', Lex, P),						% Merge our int to display purposes as intended
	atom_concat(P, ')', E),								% Basically int = "int(" + int + ")"
	lexer(S, CNext, SCont).								% Continue

% Identifiers
lexer(S, CCurr, [E | SCont]) :-
	id(CCurr),											% Determine if it's a identifier
	keyid(S, CCurr, CNext, '', Lex),					% Get the whole identifier
	!,													% Do not backtrack
	id(Lex),											% Check if the whole identifier is defined
	atom_concat('id(', Lex, P),							% Merge our identifier to display purposes as intended
	atom_concat(P, ')', E),								% Basically id = "id(" + id + ")"
	lexer(S, CNext, SCont).								% Continue

% Seperators
lexer(S, CCurr, [E | SCont]) :-
	sep(CCurr),											% Determine if it's a separator
	keysep(S, CCurr, CNext, '', Lex),					% Get the whole seperator
	!,													% Do not backtrack
	sep(Lex),											% Check if the whole separator is defined
	atom_concat('sep(', Lex, P),						% Merge our separator to display purposes as intended
	atom_concat(P, ')', E),								% Basically sep = "sep(" + sep + ")"
	lexer(S, CNext, SCont).								% Continue
	
%  ====== PHRASING ====== 
% https://www.metalevel.at/prolog/dcg


% === Program ===

program([]) --> [].										% PROGRAM ::=

program([INSTRUCTION | PROGRAM]) -->					% PROGRAM ::= INSTRUCTION ; PROGRAM
	instruction(INSTRUCTION),
	['sep(;)'],
	program(PROGRAM).

% === Instructions ===

instruction(assign(ID, EXPRESSION)) -->					% INSTRUCTION ::= ID := EXPRESSION
	id(ID),
	['sep(:=)'],
	expression(EXPRESSION).

instruction(read(ID)) -->								% INSTRUCTION ::= read ID
	['key(read)'],
	id(ID).

instruction(write(EXPRESSION)) -->						% INSTRUCTION ::= write EXPRESSION
	['key(write)'],
	expression(EXPRESSION).

instruction(if(CONDITION, PROGRAM)) --> 				% INSTRUCTION ::= if CONDITION then PROGRAM fi
	['key(if)'],
	condition(CONDITION), 
	['key(then)'],
	program(PROGRAM),
	['key(fi)'].

instruction(if(CONDITION, PROGRAM0, PROGRAM1)) --> 		% INSTRUCTION ::= if CONDITION then PROGRAM else PROGRAM fi
	['key(if)'],
	condition(CONDITION), 
	['key(then)'],
	program(PROGRAM0), 
	['key(else)'],
	program(PROGRAM1),
	['key(fi)'].

instruction(while(CONDITION, PROGRAM)) --> 				% INSTRUCTION ::= while CONDITION do PROGRAM od
	['key(while)'],
	condition(CONDITION), 
	['key(do)'],
	program(PROGRAM),
	['key(od)'].
				
% === Expressions ===

expression(COMPONENT + EXPRESSION) --> 					% EXPRESSION ::= COMPONENT + EXPRESSION
	component(COMPONENT),
	['sep(+)'],
	expression(EXPRESSION).

expression(COMPONENT - EXPRESSION) --> 					% EXPRESSION ::= COMPONENT - EXPRESSION
	component(COMPONENT),
	['sep(-)'],
	expression(EXPRESSION).

expression(COMPONENT) -->								% EXPRESSION ::= COMPONENT
	component(COMPONENT).

% === Componenets ====

component(AGENT * COMPONENT) --> 						% COMPONENT ::= AGENT * COMPONENT
	agent(AGENT),
	['sep(*)'],
	component(COMPONENT).

component(AGENT / COMPONENT) --> 						% COMPONENT ::= AGENT / COMPONENT
	agent(AGENT),
	['sep(/)'],
	component(COMPONENT).

component(AGENT mod COMPONENT) --> 						% COMPONENT ::= AGENT mod COMPONENT
	agent(AGENT),
	['key(mod)'],
	component(COMPONENT).

component(COMPONENT) -->								% COMPONENT ::= AGENT
	agent(COMPONENT).

% === Agents ===

agent(id(ID)) --> id(ID).								% AGENT ::= ID

agent(int(NUM)) --> integern(NUM).						% AGENT ::= INTEGER

agent((EXPRESSION)) -->									% AGENT ::= ( EXPRESSION )
	['sep(()'], 
	expression(EXPRESSION), 
	['sep())'].

id(ID, [Token | Tail], Tail) :-
	atom_concat('id(', IDB, Token),						% Concatenating ID Token (w/ bracket)
	atom_concat(ID, ')', IDB).

integern(NUM, [Token | Tail], Tail) :-
	atom_concat('int(', NB, Token),						% Concatenating Num Token (w/ bracket)
	atom_concat(Number, ')', NB),
	atom_number(Number, NUM).							% Convert from Atom to Number

% === Conditions ===

condition(CONJUNCTION ; CONDITION) --> 					% CONDITION ::= CONJUNCTION or CONDITION
	conjunction(CONJUNCTION),
	['key(or)'],
	condition(CONDITION).

condition(CONJUNCTION) --> 								% CONDITION ::= CONJUNCTION
	conjunction(CONJUNCTION).
		
% === Conjunction ===

conjunction(SIMPLE , CONJUNCTION) -->					% CONJUNCTION ::= SIMPLE and CONJUNCTION
	simple(SIMPLE),
	['key(and)'],
	conjunction(CONJUNCTION).

conjunction(SIMPLE) --> simple(SIMPLE).					% CONJUNCTION ::= SIMPLE

% === Simple ===
				
simple(EXPRESSION0 =:= EXPRESSION1) --> 				% SIMPLE ::= EXPRESSION = EXPRESSION
	expression(EXPRESSION0),
	['sep(=)'],
	expression(EXPRESSION1).

simple(EXPRESSION0 =\= EXPRESSION1) --> 				% SIMPLE ::= EXPRESSION /= EXPRESSION
	expression(EXPRESSION0),
	['sep(/=)'],
	expression(EXPRESSION1).

simple(EXPRESSION0 < EXPRESSION1) --> 					% SIMPLE ::= EXPRESSION < EXPRESSION
	expression(EXPRESSION0),
	['sep(<)'], 
	expression(EXPRESSION1).

simple(EXPRESSION0 > EXPRESSION1) --> 					% SIMPLE ::= EXPRESSION > EXPRESSION
	expression(EXPRESSION0), 
	['sep(>)'], 
	expression(EXPRESSION1).

simple(EXPRESSION0 >= EXPRESSION1) --> 					% SIMPLE ::= EXPRESSION >= EXPRESSION
	expression(EXPRESSION0), 
	['sep(>=)'], 
	expression(EXPRESSION1).

simple(EXPRESSION0 =< EXPRESSION1) --> 					% SIMPLE ::= EXPRESSION =< EXPRESSION
	expression(EXPRESSION0), 
	['sep(=<)'], 
	expression(EXPRESSION1).

simple((CONDITION)) -->									% SIMPLE ::= ( CONDITION )
	['sep(()'], 
	condition(CONDITION), 
	['sep())'].
