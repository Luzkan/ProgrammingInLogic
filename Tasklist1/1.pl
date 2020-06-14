% Marcel Jerzyk 244979
% https://www.youtube.com/watch?v=SykxWpFwMGs (16:40)

is_mom(X) :-
    mom(X,_).
is_papa(X) :-
    papa(X,_).
is_son(X) :-	
    parent(_,X),
	male(X).
is_sis(X,Y) :-
	siblings(X,Y),
	female(X).
is_grandpa(X,Y) :-	
    parent(X,Z),
    parent(Z,Y).
siblings(X,Y) :-
    parent(Z,X),
    parent(Z,Y),
    X\=Y.

% Mom must be a Parent and a Female
mom(X,Y) :-
    parent(X,Y),
    female(X).
% Papa must be a Parent and a Male
papa(X,Y) :-
	parent(X,Y),
	male(X).

% Spawning few people
male(kamil).
male(kuba).
female(jagoda).
female(justyna).
female(julia).

% Creating a family where Jagoda & Julia are sisters and Kuba is grandparent
% Kamil & Justyna -> Parents(Jagoda)
parent(kamil,jagoda).
parent(justyna,jagoda).
% Kamil & Justyna -> Parents(Julia)
parent(kamil,julia).
parent(justyna,julia).
% Grandparent
% Kuba -> Parent(Kamil)
parent(kuba,kamil).

/**
 * Console cmds:
 * female(X).
 * is_son(jagoda). 
 * is_papa(kamil).
 * is_papa(kuba).
 * is_grandpa(kuba, julia).
 * is_sis(jagoda, julia).
**/
