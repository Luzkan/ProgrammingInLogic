% Returns true if all elements form LeftArg exist in RightArg list
%   it builds on the built-in select predicate
%       select(?Elem, ?List1, ?List2):
%       true when List1, with Elem removed, results in List
select([A | As], S) :- 	
    select(A, S, S1),
    select(As, S1).
select([], _). 
 
% Test's if A and B exists in list C (among other elements)
%	but it must satisfy the fact that they are neighbors in that list
nextto(A, B, C) :-				% Next To exist to make leftof in reversed mapping
    leftof(A, B, C).			% 	Return mapping of {A, B} in reverse ({B, A})
nextto(A, B, C) :-
    leftof(B, A, C).
leftof(A, B, C) :-
    append(_, [A, B | _], C).	% Given only C:
								%	A and B would return one element
								% 	one by one from beginning to end, ex:
								%	C = [1, 2, 3, 4]
								% 	{A, B} -> {1, 2}, {2, 3}, {3, 4}

rybki(Master) :-
            % House1 / House2 / House3 / House4/ House5
            % Color / Nation / Pet / Drink / Smokes (in Polish language)

            % Norweg = dom1 (1),   _,     Mleko = dom3 (8),        _, _
    Hints = [(_, norweg, _, _, _), _,     (_, _, _, mleko, _), _, _], 
            
            % Anglik -> Czerwony (2),     Szwed -> Pies (11)           Duńczyk -> Herbata (4)         Niemiec -> Fajka (7)
    select( [(red, englishman, _, _, _),  (_, szwed, pies, _, _),      (_, dane, _, tea, _),          (_, german, _, _, fajka) ], Hints),

            % Skręty -> Ptaki (10)        Żółty -> Cygaro (6)          Piwo -> Mentole (14) 
    select( [(_, _, birds, _, skret),     (zolty, _, _, _, cygaro),  (_, _, _, beer, mentole) ], Hints), 

            % Zielony -> Kawa (15)       Zielony PO LEWEJ Białego (3)
    leftof(  (green, _, _, coffee, _),    (white, _, _, _, _),        Hints),

            % Konie || Zolty (13)
    nextto(  (zolty, _, _, _, _),       (_, _, horse, _, _),        Hints),

            % Light || Koty (5)
    nextto(  (_, _, _, _, light),         (_, _, cats, _, _),         Hints),

            % Light || Woda (9)
    nextto(  (_, _, _, _, light),         (_, _, _, water, _),        Hints),

            % Norweg || Niebieski (12)
    nextto(  (_, norweg, _, _, _),     (blue, _, _, _, _),         Hints),

    member(  (_, Master, rybki, _, _),    Hints).
 
% time(rybki(Kto)).
% 2,676 inferences, 0.001 CPU in 0.001 seconds (99% CPU, 2411830 Lips)