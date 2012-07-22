" Test fetching visual selection up from text running into a closed fold.
" Tests that the closed fold counts as one line and is swapped in full.
" Tests that the cursor moves to the new line and moves to column 1.

execute '9normal Vjjw[f'

call Quit()
