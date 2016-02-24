" Test normal mode repeat of swapping characterwise selection down over some at another position.

set selection=inclusive

10normal wwve3]E
normal bb.

call Quit(1)
