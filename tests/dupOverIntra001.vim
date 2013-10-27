" Test duplicating characterwise selection directly up.
" Tests that the cursor moves to the beginning of the original selection.

execute '10normal wwve[d'

call Quit(1)
