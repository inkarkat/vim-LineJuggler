" Test duplicating 3 lines running over and into a closed fold.
" Tests that both closed folds are duplicated in full.
" Tests that the cursor moves with the line and moves to column 1.

execute '20normal znwzN3]D'

call Quit()
