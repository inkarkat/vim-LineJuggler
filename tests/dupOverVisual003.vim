" Test duplicating visual selection 2 up from the opposite end.
" Tests that the cursor moves with the line and moves to column 1.

execute '11normal Vjjw2[d'

call Quit()
