% Marcel Jerzyk 244979
primeOld(LO, HI, N) :-
    between(LO, HI, N),
    isPrimeOld(N).

% (N < 2) -> There's no primes
% (N = 2) -> It is a prime number
% (N > 2) -> It's not true that is has a divisor
isPrimeOld(N) :- N < 2, false.
isPrimeOld(2) :- true.
isPrimeOld(N) :- \+ divisible(N, 2).

% It's divisible if mod == 2 equals to 0 or
% 					mod == X equals to 0 where X is in range (2 to N-1)
divisible(X, Y) :-
    0 is X mod Y;
    (   
      	X > Y+1,
      	divisible(X, Y+1)
    ).

% Now thinking about improving it from that iterative method:
% - "2" is the only even prime number
% - any number greater than half the original does not divide evenly

prime(LO, HI, N) :-
    between(LO, HI, N),
    isPrime(N).

isPrime(2) :- true.
isPrime(3) :- true.
isPrime(N) :-
    N > 3,
    N mod 2 =\= 0,
    isPrimeTest(N, 3).

isPrimeTest(X, N) :-
    N*N > X	-> true;
    (
    	X mod N =\= 0,
        isPrimeTest(X, N+2)
    ).
    

/**
 * Console cmds:
 * primeOld(2, 3000, N).
 * Bench: 105.032 seconds cpu time
 * 
 * prime(2, 3000, N).
 * Bench: 0.290 seconds cpu time
 * 
 * prime(2, 10000, N).
 * Bench: 0.928 seconds cpu time
**/