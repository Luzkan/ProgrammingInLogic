% Merge - (
%			IN1 = [non-decreasing stream of numbers],
%			IN2 = [non-decreasing stream of numbers],
%			OUT = [merged /IN1, IN2/ into non-decreasing stream of numbers]
%		  )

% Examples:
%  ?- merge([1, 3], [2, 4], X).
%  X = [1, 2, 3, 4].
%  ?- merge([1, 3 | A], [2, 4 | B], X).
%  X = [1, 2, 3|_...],

merge(IN1, IN2, OUT) :-
    % Execute Goal if Conditions are true
	when((                                          % ===== Conditions
            nonvar(IN1),                            %       IN1 is not a free variable
            nonvar(IN2)                             %       IN2 is not a free variable
        ),                                          %
        (                                           % ===== Goal
            (IN1 = [SMALLEST_1 | T1],               % ----- If possible: Get Head of the IN1 and IN2
             IN2 = [SMALLEST_2 | T2]) ->            % 
                (                                   % ----- Then: 
                    (SMALLEST_1 < SMALLEST_2) ->    %   --- If: SMALLEST_1 is smaller in comparision to SMALLEST_2
                        OUT = [SMALLEST_1 | OUT2],  %       Add SMALLEST_1 to the front and do
                        merge(T1, IN2, OUT2);       %       Recursive Call on chosen tail (Tail1) andunchosen stream (IN2) 
                                                    %   --- Else:
                        OUT = [SMALLEST_2 | OUT2],  %       Add SMALLEST_2, Recursive Call(Tail2 and IN1)
                        merge(IN1, T2, OUT2)        %    
                );	                                % 
                (                                   % ----- Else:
                    (IN1 = [SMALLEST_1 | T1] ->     %   --- If: Try to get Smallest from IN1 (notice: check if IN1 is empty / length(IN1) > 0)
                        OUT = IN1);                 %       Get it all as OUT
                                                    %   --- Else:
                    (IN2 = [SMALLEST_2 | T2] ->     %     - If: Try to get Smallest from IN2
                        OUT = IN2;                  %       Get it all as OUT
                                                    %     - Else:
                        OUT = [])                   %       Both IN1 and IN2 returned False (they are empty)
                )
        )).
