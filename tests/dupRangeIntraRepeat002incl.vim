" Test normal mode repeat of duplicating characterwise selection down twice.

set selection=inclusive

10normal wwvel2]D
normal .

call Quit(1)
