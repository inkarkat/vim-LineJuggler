" Test duplicating current line 1 down across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '5normal w1]d'

call Quit()
