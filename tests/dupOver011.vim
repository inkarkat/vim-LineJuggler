" Test duplicating first line one up.
" Tests that the cursor moves with the line and moves to column 1.

execute '1normal w[d'

call Quit()
