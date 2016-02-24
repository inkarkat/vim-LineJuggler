" Test duplicating visual selection across 2 up from the opposite end.
" Tests that the count is relative to the start of the selection.
" Tests that the cursor moves with the line and moves to column 1.

execute '11normal Vjjw2[d'

call Quit()
