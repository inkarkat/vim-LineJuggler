" Test normal mode repeat of duplicating characterwise selection at another position.

set selection=inclusive

10normal wwvel4]d
12normal ww.

call Quit(1)
