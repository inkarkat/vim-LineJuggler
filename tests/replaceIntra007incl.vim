" Test replacing characterwise selection from 3 up across a fold.
" Tests that the closed fold is counted as one line.

set selection=inclusive

18normal wve3]r

call Quit(1)
