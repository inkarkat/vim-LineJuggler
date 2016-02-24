" Test duplicating current line across one up.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal w1[d'

call Quit()
