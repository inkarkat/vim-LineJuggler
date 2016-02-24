" Test normal mode repeat of swapping characterwise selection up directly at another position.

set selection=inclusive

10normal wwve[E
normal $b.

call Quit(1)
