" Test exchanging visual selection to text running into a closed fold.
" Tests that the closed fold counts as one line and is swapped in full.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '9normal Vjjw]E'

call Quit()
