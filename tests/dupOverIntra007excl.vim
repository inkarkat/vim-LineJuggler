" Test duplicating characterwise selection down over 3.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=exclusive

execute '10normal wwve3]d'

call Quit(1)
