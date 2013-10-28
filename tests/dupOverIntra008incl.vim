" Test duplicating characterwise selection up to overflowing beginning.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=inclusive

execute '10normal wwve99[d'

call Quit(1)
