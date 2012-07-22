" Test fetching visual selection from text running over and into a closed fold.
" Tests that the closed folds count as one line and are swapped in full.
" Tests that the cursor moves to the new line and moves to column 1.

execute '9normal Vjjw7[f'

call Quit()
