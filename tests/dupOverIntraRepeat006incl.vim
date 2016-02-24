" Test normal mode repeat of duplicating characterwise selection over a closed fold.

set selection=inclusive

10normal wwvel4]d
14normal .

call Quit(1)
