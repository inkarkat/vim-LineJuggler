" Test replacing with one line 3 up.
" Tests that the cursor stays in the current line and moves to column 1.

execute '12normal w3]r'

call Quit()
