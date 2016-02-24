" Test normal mode repeat of moving characterwise selection up directly at the same position.

set selection=exclusive

10normal wwve[e
normal .

call Quit(1)
