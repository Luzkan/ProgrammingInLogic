% Filozofie - (
%             )
% Notice: Filozofie executes five threads representing philosophers

% Philosophres - (
%                )
% Notice: Philosopher is a thread running in an endless loop
%         Philosopher can: think -> pick up fork -> eat -> put down fork
%                                        ^                     ^
%                                        |                     |
%                                       on his left AND right side

% --- Dev Stuff ---
% problem: https://pl.wikipedia.org/wiki/Problem_ucztuj%C4%85cych_filozof%C3%B3w
% corouting: https://www.swi-prolog.org/pldoc/man?section=coroutining
% freeze: https://www.swi-prolog.org/pldoc/doc_for?object=freeze/2
% when: https://www.swi-prolog.org/pldoc/doc_for?object=when/2


filozofie :-
                                                    % ===== Creating Forks
    F1 is 1,                                        %       Forks = 1 -> Fork available
    F2 is 1,                                        %       Forks = 0 -> Fork picked up by philosopher
    F3 is 1,
    F4 is 1,
    F5 is 1,
                                                    % ===== Philosophers and their Forks
    philosopher('Aristotle', F1, F2, 1)             %
    philosopher('Kant', F2, F3, 2)                  %       Fork_1     Aristotle     Fork_2
    philosopher('Spinoza', F3, F4, 3)               %   Russel                          Kant
    philosopher('Marx', F4, F5, 4)                  %   Fork_5                          Fork_3  
    philosopher('Russell', F5, F1, 5)               %       Marx        Fork_4       Spinoza

    TIME_1 is random(10)+ 2,

pickforks(PHILOSOPHER, FORK1, FORK2, RESULT) :-
    freeze(                                         % ===== Delay Goal: Until RESULT is bound
        RESULT,                                     % 
        (                                           % ===== Goal
            FORK1 is 1 ->                           % ----- If: Left Fork is available
            (                                       %
            FORK2 is 1 ->                           %   --- If: Right Fork is available
                NFORK1 is 0,                        %       Mark forks unavailable to other philosophers
                NFORK2 is 0,                        %       
                NRESULT = 1                         %
                writeln('Forks Picked Up')
                eat(PHILOSOPHER, NFORK1, NFORK2, NRESULT)
            )
        )).

eat(PHILOSOPHER, FORK1, FORK2, RESULT) :-
    pass

releasefork(PHILOSOPHER, FORK1, FORK2, RESULT) :-
    pass

philosopher(Name, Fork1, Fork2, IDPHILO) :-
    writeln('Summoning Philosopher')
    thread_create(philo(Name, Fork1, Fork2), IDPHILO),
