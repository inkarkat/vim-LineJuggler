" Test normal mode repeat of replacing characterwise selection from up at the same position.

set selection=exclusive

10normal wwve3]r
normal .

call Quit(1)
