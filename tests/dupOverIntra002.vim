" Test duplicating characterwise selection directly down.
" Tests that the cursor moves to the beginning of the duplicated selection.

execute '10normal wwve]d'

call Quit(1)
