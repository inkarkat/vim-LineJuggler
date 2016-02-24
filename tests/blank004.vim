" Test inserting 3 blank lines after current line.
" Tests that the cursor remains on the original line and moves to column 1.

execute '12normal w3] '

call Quit()
