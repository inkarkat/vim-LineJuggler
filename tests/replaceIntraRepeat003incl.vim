" Test visual mode repeat of replacing characterwise selection from down.

set selection=inclusive
runtime plugin/visualrepeat.vim

10normal wwve2[r
9normal wwve.

call Quit(1)
