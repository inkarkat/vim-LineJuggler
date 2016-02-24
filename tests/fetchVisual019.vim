" Test fetching folded multi-line visual selection up with folded text.
" Tests that the closed folds in the selection are counted as one line each, not
" the number of contained lines.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '20normal V3j16]f'

call Quit()
