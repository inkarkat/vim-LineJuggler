" Test inserting blank line at the end of the buffer.
" Tests that the cursor remains on the original line and moves to column 1.

execute '$normal w] '

call Quit()
