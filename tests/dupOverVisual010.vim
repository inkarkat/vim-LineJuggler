" Test duplicating visual selection clipping to the last line.
" Tests that the cursor moves with the line and moves to column 1.

execute '9normal Vjjw99]d'

call Quit()
