" Test duplicating characterwise selection up over 3.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=exclusive

10normal wwve3[d

call Quit(1)
