% Marcel Jerzyk 244979
% Block_(n) is on Block_(n+1)
on(b1, b2).
on(b2, b3).
on(b3, b4).

% Block1 is above Block2 if
%		[BlockX is on some block_Z AND try to find that blockZ on blockY]
%		or
%		[BlockX is on BlockY]
above(BlockX, BlockY) :- 
    (
        on(BlockX, Z),
        above(Z, BlockY)
    );
    on(BlockX, BlockY).

/**
 * Console cmds:
 * above(b1, b4).
**/