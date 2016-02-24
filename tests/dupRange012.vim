" Test duplicating last line down.
" Tests that the cursor moves with the line and moves to column 1.

execute '$normal w]D'

call Quit()
