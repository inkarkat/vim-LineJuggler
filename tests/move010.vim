" Test moving current folded line one down.
" Tests that the line is not inserted on the adjacent line, but on the line next
" to the fold.
" Tests that the line is not moved into, but across the fold.
" Tests that the cursor stays relative to the fold and moves to column 1.

execute '22normal znwzN]e'

call Quit()
