" Test fetch clipping of a large count to the last line.
" Tests that the cursor moves to the new line and moves to column 1.

execute '12normal w99[f'

call Quit()
