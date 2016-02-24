" Test duplicating one-line visual selection 3 up across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '18normal V3[d'

call Quit()
