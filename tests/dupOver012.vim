" Test duplicating last line one down.
" Tests that the cursor moves with the line and moves to column 1.

execute '$normal w]d'

call Quit()
