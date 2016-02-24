" Test duplicating characterwise selection up twice.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=inclusive

10normal wwve2[D

call Quit(1)
