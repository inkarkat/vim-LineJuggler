" Test fetching one-line visual selection from 5 down across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '18normal V5[f'

call Quit()
