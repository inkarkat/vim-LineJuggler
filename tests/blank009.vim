" Test inserting blank line at the start of the buffer.
" Tests that the cursor remains on the original line and moves to column 1.

execute '1normal w[ '

call Quit()
