" Test normal mode repeat of moving characterwise selection over a closed fold.

set selection=inclusive

10normal wwve3]e
14normal .

call Quit(1)
