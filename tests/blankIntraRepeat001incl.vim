" Test normal mode repeat of inserting characterwise blanks after selection.

set selection=inclusive

execute '10normal wwve3] '
normal .

call Quit(1)
