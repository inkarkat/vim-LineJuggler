" Test duplicating characterwise selection up over 1.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=inclusive

10normal wwve1[d

call Quit(1)
