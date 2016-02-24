" Test inserting blank line after current folded line.
" Tests that the line is not inserted on the adjacent line, but on the line next
" to the fold.
" Tests that the cursor remains on the original line and moves to column 1.

execute '22normal znwzN] '

call Quit()
