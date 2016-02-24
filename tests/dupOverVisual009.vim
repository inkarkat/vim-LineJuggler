" Test duplicating visual selection clipping to the first line.
" Tests that the cursor moves with the line and moves to column 1.

execute '13normal Vkkw99[d'

call Quit()
