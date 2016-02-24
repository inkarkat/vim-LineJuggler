" Test normal mode repeat of inserting characterwise blanks over a closed fold.

set selection=inclusive

execute '10normal wwve3] '
14normal .

call Quit(1)
