" Test visual mode repeat of swapping characterwise selection down over some.

set selection=inclusive
runtime plugin/visualrepeat.vim

10normal wwve2]E
9normal wwve.

call Quit(1)
