" Test normal mode repeat of moving characterwise selection up directly at another position.

set selection=inclusive

10normal wwve[e
normal $b.

call Quit(1)
