" Test duplicating characterwise selection down over 1.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=exclusive

execute '10normal wwve1]d'

call Quit(1)
