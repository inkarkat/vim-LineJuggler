" Test normal mode repeat of swapping characterwise selection down over some at the same position.

set selection=inclusive

10normal wwve3]E
normal .

call Quit(1)
