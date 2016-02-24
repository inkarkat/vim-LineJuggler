" Test duplicating 3 lines running into a closed fold.
" Tests that the closed fold is duplicated in full.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal znwzN3]D'

call Quit()
