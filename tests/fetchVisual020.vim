" Test fetching folded multi-line visual selection down with folded text.
" Tests that the closed folds in the selection are counted as one line each, not
" the number of contained lines.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '3normal V2j10[f'

call Quit()
