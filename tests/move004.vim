" Test moving current line 3 down.
" Tests that the cursor moves with the line and moves to column 1.

execute '10normal w3]e'

call Quit()
