" Test duplicating characterwise selection directly down.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=inclusive

10normal wwve]d

call Quit(1)
