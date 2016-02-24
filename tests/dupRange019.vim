" Test duplicating from inside a closed fold.
" Tests that all lines in the closed fold are duplicated in full.
" Tests that the cursor moves with the line and moves to column 1.

execute '14normal znwzN[D'

call Quit()
