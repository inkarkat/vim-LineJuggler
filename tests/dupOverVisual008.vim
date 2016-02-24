" Test duplicating visual selection across down.
" Tests that the cursor moves with the line and moves to column 1.

execute '9normal Vjjw]d'

call Quit()
