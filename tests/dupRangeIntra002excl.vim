" Test duplicating characterwise selection down.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=exclusive

10normal wwve]D

call Quit(1)
