% Variance: arithmetic mean of squares of deviations from their arithmetic mean
% 	Var = (1/n) * sum{1 to n}[x_{i} - avg([List])]^2

average(List, Avg) :-                   % Calculate Average of a List
	average(List, Avg, 0, 0).       

average([H | T], Avg, Size, Sum) :-     % It's a recursive function that counts on first element
	SizeI is Size + 1,                  % Iterativelly count size to SizeIterator
	SumI is Sum + H,                    % Add current first element to the sum of the array
	average(T, Avg, SizeI, SumI).       % Recursive Call on array w/o the first element

average([], Avg, Size, Sum) :-          % When we reach empty array
    Avg is Sum / Size.                  % We can count the average


% https://www.geeksforgeeks.org/program-for-variance-and-standard-deviation-of-an-array/
variance(List, Sum) :-
	average(List, Avg),					% Get Average
	variance(List, 0, 0, Avg, Sum).		% Calculate Variance with it

variance([H | T], Size, Sum, Mean, Var) :-
    C is H - Mean,						% [a[1] * mean]
    Diff is C * C,						% Diff = [a[1] * mean] * [a[1] * mean]
    SqDiff is Sum + Diff,				% SqDiff += Diff
    SizeI is Size + 1,
    variance(T, SizeI, SqDiff, Mean, Var).

variance([], Size, Sum, _, Var) :-
    Var is Sum / Size.
