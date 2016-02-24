" Test replacing visual selection from text running over and into a closed fold.
" Tests that the closed folds count as one line and are swapped in full.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '9normal Vjjw7[r'

call Quit()
