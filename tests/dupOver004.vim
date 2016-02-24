" Test duplicating current line across 3 down.
" Tests that the cursor moves with the line and moves to column 1.

execute '10normal w3]d'

call Quit()
