" Test duplicating current line across 3 up.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal w3[d'

call Quit()
