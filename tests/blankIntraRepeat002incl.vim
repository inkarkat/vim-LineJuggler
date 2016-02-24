" Test normal mode repeat of inserting characterwise blanks before selection.

set selection=inclusive

execute '10normal wwve3[ '
normal .

call Quit(1)
