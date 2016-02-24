" Test duplicating current line 3 up across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '18normal w3[d'

call Quit()
