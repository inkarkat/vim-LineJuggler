" Test normal mode repeat of replacing characterwise selection from down at the same position.

set selection=inclusive

10normal wwve3[r
normal .

call Quit(1)
