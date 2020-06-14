% This task is about creating predicate 'schedule'
% that finds optimal way of executing 'tasks'
% so that the last task is executed asap.

% Task is defined by a time needed to complete
% and two resources that need to be spend on it.
% The amount of resources per 'moment' is limited
% by resources constraint.

% schedule(Horizon, Starts, MakeSpan)
%    - Horizon:  The End of Available Time Range
%    - Starts:   List of starting time for tasks 
%    - MakeSpan: Deadline for completion of the latest task
% Examples:
%  ?- schedule(20, S, MS).
%  MS = 11,
%  S = [0, 0, 3, 5, 2, 8, 0]

% ===== https://www.swi-prolog.org/pldoc/man?section=clpfd
% Needed for the domain (ins) and distinct ints evaluation (#\=)
:- use_module(library(clpfd)).						

% resources(Res1, Res2)
%   - defines the amount of res1 and res2
%     given at any single moment
resources(5, 5).

% tasks (& task)
%   - holds the tasks, where a single
% 	  task is 3-element list that holds:
%       - duration of execution
%		- required resource1 units
%		- required resource2 units
tasks([[2, 1, 3],								% Time: 2 | Resources: 1, 3
	   [3, 2, 1],								% Time: 3 | Resources: 2, 1
	   [4, 2, 2],								% Time: 4 | Resources: 2, 2
	   [3, 3, 2],								% Time: 3 | Resources: 3, 2
	   [3, 1, 1],								% Time: 3 | Resources: 1, 1
	   [3, 4, 2],								% Time: 3 | Resources: 4, 2
	   [5, 2, 1]]).								% Time: 5 | Resources: 2, 1

% Before proceeding further I need to clarify prolog's cumulative&task
% https://www.swi-prolog.org/pldoc/man?predicate=cumulative/2
% task(S, D, E, R, ID)
%    - S:  starting time
%    - D:  its duration
%    - E:  finishing time
%    - R:  resources it needs
%    - ID: identifier

jobs([], [], [], [], 0) :- !.
jobs([[D, Res1, Res2]|TasksLeft],				% Get a Task (mark Duration, Resource1, Resource2)
	 [task(S, D, E, Res1, _)|Res1L],			% Task it with the resource1
	 [task(S, D, E, Res2, _)|Res2L],			% Task it with the resource2
	 [S|SN],									% The starting time
	 MakeSpan) :-								% Total Time
	jobs(TasksLeft,	Res1L, Res2L, SN, E2),  	% Recursivelly go for next one
    MakeSpan #= max(E, E2).						% After going back from recursion, remember highest ending time

schedule(Horizon, Starts, MakeSpan) :-
    tasks(Tasks),								% Get the Tasks
    jobs(Tasks,									% All Tasks
		 TRes1,									% Tasks w/ resource1 consumption 
		 TRes2,									% Tasks w/ resource2 consumption 
		 Starts,								% Starting time lists
		 MakeSpan),								% Max Retrieved Ending Time
    Starts ins 0..Horizon,						% Constraint the time (from 0 to End Time)
    resources(Res1PerMoment, Res2PerMoment),	% Constraint the resources (per 'moment')
    cumulative(TRes1, [limit(Res1PerMoment)]),	% Obtaining a schedule w/ res1
    cumulative(TRes2, [limit(Res2PerMoment)]),	% Obtaining a schedule w/ res2
    once(										% Retrieve only one solution where 
		labeling([min(MakeSpan)], Starts)).		% labels sorts it by minimum MakeSpan - it's the best solution