" Test normal mode repeat of replacing characterwise selection from up at another position.

set selection=inclusive

10normal wwve]r
normal $gE.

call Quit(1)
