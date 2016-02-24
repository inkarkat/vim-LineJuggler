" Test normal mode repeat of moving characterwise selection down over some at the same position.

set selection=inclusive

10normal wwve3]e
normal .

call Quit(1)
