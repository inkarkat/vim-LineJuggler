" Test normal mode repeat of replacing characterwise selection until exhaustion.

set selection=exclusive

10normal wwve3[r
normal .....

call Quit(1)
