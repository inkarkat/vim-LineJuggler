" Test moving current folded line one down.
" Tests that all folded lines are moved, not just the current line.
" Tests that the line is not moved into, but across the fold.
" Tests that the cursor stays relative to the fold and moves to column 1.

execute '22normal znwzN]e'

call Quit()
