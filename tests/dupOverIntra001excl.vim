" Test duplicating characterwise selection directly up.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=exclusive

10normal wwve[d

call Quit(1)
