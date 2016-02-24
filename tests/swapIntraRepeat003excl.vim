" Test normal mode repeat of swapping characterwise selection up directly at the same position.

set selection=exclusive

10normal wwve[E
normal .

call Quit(1)
