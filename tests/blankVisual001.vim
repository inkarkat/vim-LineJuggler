" Test inserting blank line before visual selection.
" Tests that the line is not inserted on the current line, but on the line next
" to the selection.
" Tests that the cursor remains on the original line and moves to column 1.

execute '9normal V4jw[ '

call Quit()
