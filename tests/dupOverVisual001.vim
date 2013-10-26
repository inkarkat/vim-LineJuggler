" Test duplicating visual selection 2 up.
" Tests that the cursor moves with the line and moves to column 1.

execute '13normal Vkkw2[d'

call Quit()
