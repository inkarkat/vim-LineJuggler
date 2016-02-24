" Test visual mode repeat of duplicating characterwise selection down over some.

set selection=inclusive
runtime plugin/visualrepeat.vim

10normal wwvel4]d
12normal wvel.

call Quit(1)
