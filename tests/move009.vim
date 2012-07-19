" Test moving current folded line one up.
" Tests that the line is not inserted on the adjacent line, but on the line next
" to the fold.
" Tests that the cursor stays relative to the fold and moves to column 1.

execute '22normal znwzN[e'

call Quit()
