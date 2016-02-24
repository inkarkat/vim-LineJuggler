" Test exchanging folded multi-line visual selection up with folded text.
" Tests that the closed folds in the selection are counted as one line each, not
" the number of contained lines.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '20normal V3j16[E'

call Quit()
