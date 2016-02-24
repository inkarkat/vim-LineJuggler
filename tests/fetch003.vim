" Test fetching one line over down.
" Tests that this is the mirror of ]f.
" Tests that the cursor moves to the new line and moves to column 1.

execute '9normal w2[f'

call Quit()
