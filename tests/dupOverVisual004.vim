" Test duplicating visual selection 2 down from the opposite end.
" Tests that the count is relative to the end of the selection.
" Tests that the cursor moves with the line and moves to column 1.

execute '11normal Vkkw2]d'

call Quit()
