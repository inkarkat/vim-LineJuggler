" Test inserting blank line before current line.
" Tests that the cursor remains on the original line and moves to column 1.

execute '12normal w[ '

call Quit()
