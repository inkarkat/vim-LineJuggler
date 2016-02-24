" Test replace clipping of a large count from the first line.
" Tests that the cursor stays in the current line and moves to column 1.

execute '12normal w99]r'

call Quit()
