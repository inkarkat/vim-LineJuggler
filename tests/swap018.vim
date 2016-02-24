" Test exchanging folded line with text up running over and into a closed fold.
" Tests that the closed folds count as one line and are swapped in full.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '14normal znwzN8[E'

call Quit()
