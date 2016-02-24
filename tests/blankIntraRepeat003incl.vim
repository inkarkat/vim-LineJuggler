" Test visual mode repeat of inserting characterwise blanks after selection.

set selection=inclusive
runtime plugin/visualrepeat.vim

execute '10normal wwve3] '
12normal wvel.

call Quit(1)
