" Test replacing with one line down.
" Tests that the cursor stays in the current line and moves to column 1.

execute '12normal w[r'

call Quit()
