% Plecak - (
%			 V = [list represting value for each element],
%            W = [list representing weight for each element],
%            C = [integer representing the total capacity of backpack],
%            R = [Variables as output and domain (range)]
%		   )
% Notice: Length(V) == Length(W) == Length(R)
% Output: Read list R as bool for items (not picked up/picked up) -> (0/1)
%
% Examples:
%  ?- plecak([10, 7, 1, 3, 2], [9, 12, 2, 7, 5], 15, X).
%  X = [1, 0, 0, 0, 1].

% RosettaCode on this problem (Prolog Section): https://rosettacode.org/wiki/Knapsack_problem/0-1#Prolog

                                    % ===== https://www.swi-prolog.org/pldoc/man?section=clpfd
:- use_module(library(clpfd)).      %       Needed for the domain (ins) and distinct ints evaluation (#\=)

% Discrete Knapsack Problem
plecak(V, W, C, R) :-     
	length(V, N),                   % Check if Length of list VALUES and list WEIGHT is equal
	length(W, N),                   %       Additionaly Set Variables length with that length
	length(R, N),                   % 
	R ins 0..1,                     % Each of the Variables element gets constraint by domain {0, 1}
									%       Map it as bool:   0 -> Not Picked Up |    1 -> Picked Up
                                    % ProductScalar is True if scalar product of (Weights/Values) and Variables is in relation to Expression
	scalar_product(W, R, #=, WM),   %       Total Weight of the stolen items
	scalar_product(V, R, #=, VM),   %       Total Value of the stolen items
	WM #=< C,                       % Check if Weight exceeds given Capacity of Backpack
	once(labeling([max(VM)], R)).   % Labelling on the Maximum Value 
                                    %       Using once() to get best result