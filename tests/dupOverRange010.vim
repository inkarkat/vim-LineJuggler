" Test duplicating current folded line two down.
" Tests that all folded lines are duplicated, not just the current line.
" Tests that the line is not duplicated into, but after the fold.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '22normal znwzN]1d'

call Quit()
