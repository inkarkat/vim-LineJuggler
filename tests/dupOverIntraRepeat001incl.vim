" Test normal mode repeat of duplicating characterwise selection directly down.

set selection=inclusive

10normal wwve]d
normal .

call Quit(1)
