" Test duplicating current folded line up.
" Tests that all folded lines are duplicated, not just the current line.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '22normal znwzN[D'

call Quit()
