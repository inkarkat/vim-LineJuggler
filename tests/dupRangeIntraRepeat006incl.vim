" Test normal mode repeat of duplicating characterwise selection over a closed fold.

set selection=inclusive

10normal wwvel2]D
14normal .

call Quit(1)
