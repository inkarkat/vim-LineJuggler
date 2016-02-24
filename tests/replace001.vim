" Test replacing with one line up.
" Tests that the cursor stays in the current line and moves to column 1.

execute '12normal w]r'

call Quit()
