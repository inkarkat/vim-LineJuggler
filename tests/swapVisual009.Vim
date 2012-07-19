" Test exchanging visual selection to text down running over and into a closed fold.
" Tests that the closed folds count as one line and are swapped in full.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '9normal Vjjw7]E'

call Quit()
