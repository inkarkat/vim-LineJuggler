" Test duplicating current line 5 down across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '18normal w5]d'

call Quit()
