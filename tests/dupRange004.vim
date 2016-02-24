" Test duplicating 3 lines down.
" Tests that the cursor moves with the line and moves to column 1.

execute '9normal w3]D'

call Quit()
