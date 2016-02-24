" Test visual mode repeat of moving characterwise selection down over some.

set selection=inclusive
runtime plugin/visualrepeat.vim

10normal wwve2]e
9normal wwve.

call Quit(1)
