" Test duplicating current line down.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal w]D'

call Quit()
