% Split - (
%           IN = [stream of numbers],
%           OUT1 = [stream of numbers from IN with len == len(OUT1) +/- 1],
%           OUT2 = [stream of numbers from IN with len == len(OUT2) +/- 1],
%         )
% Notice: Every element from IN appears only once in either OUT1 or OUT2
% Examples:
%  ?- split([a, b, c, d], OUT1, OUT2).
%  OUT1 = [a, c],
%  OUT2 = [b, d].

% Merge_Sort - (
%                IN = [stream of numbers],
%                OUT = [sorted stream of numbers]
%              )
% Notice: IN gets split into two streams and then sorted recursivelly into OUT
% Examples:
%  ?- merge_sort([5, 1, 3, 2, 4], X).
%  X = [1, 2, 3, 4, 5].
% 
%  ?- merge_sort(X, Y), X = [4, 1, 3, 2].
%  X = [4, 1, 3, 2],
%  Y = [1, 2, 3, 4].


split(IN, OUT1, OUT2) :-
    split(IN, OUT1, OUT2, 0).

merge_sort(IN, OUT) :-
    freeze(                                         % ===== Delay Goal: Until IN is bound
        IN,                                         % 
        (                                           % ===== Goal
            IN = [H | T] ->                         % ----- If possible: Get Head of the IN
            freeze(                                 %   === Delay Goal: Until IN's tail is bound
                T,                                  %
                (                                   %   === Goal
                \+ (T = []) ->                      %   --- If: Tail is not empty (notice: So IN has more than 1 element (because Head))
                    split(IN, TOSORT1, TOSORT2),    %       Split it into two parts
                    merge_sort(TOSORT1, SORTED1),   %       Sort Part1
                    merge_sort(TOSORT2, SORTED2),   %       Sort Part2
                    merge(SORTED1, SORTED2, OUT);   %       Merge with ours Task1 Merge (reminder: into non-decreasing order)
                                                    %   --- Else:
                    OUT = [H]                       %       IN's Tail is empty (IN has 1 element and we have it as  Head)
                ));                                 % ----- Else:
            OUT = []                                %       IN is completly empty
        )).  
    
split(IN, OUT1, OUT2, GOTO) :-
    freeze(                                         % ===== Delay Goal: Until IN is bound
        IN,                                         % 
        (                                           % ===== Goal
            IN = [H | T] ->                         % ----- If possible: Get Head of the IN
            (                                       %
            GOTO is 1 ->                            %   --- If: GOTO directs to OUT1 
                OUT1 = [H | T1],                    %       Add Head of IN to OUT1
                GOTOT is GOTO + 1,                  %       Switch GOTO to direct to OUT2
                GOTO2 is GOTOT mod 2,               %
                split(T, T1, OUT2, GOTO2);          %       Recursive Call
                                                    %   --- Else: GOTO directs to OUT2 (notice: in reality it is equal to 0)
                OUT2 = [H | T2],                    %       Add Head of IN to OUT2
                GOTOT is GOTO + 1,                  %       Switch GOTO to direct to OUT1
                GOTO1 is GOTOT mod 2,               %
                split(T, OUT1, T2, GOTO1)           %       Recursive Call
            );                                      % ----- Else: 
                                                    %       IN is empty
            OUT1 = [],                              %
            OUT2 = []                               %
        )).