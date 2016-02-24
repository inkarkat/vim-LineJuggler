" Test normal mode repeat of moving characterwise selection down over some at another position.

set selection=inclusive

10normal wwve3]e
normal bb.

call Quit(1)
