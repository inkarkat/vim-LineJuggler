" Test clipping of a large count to the last line.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal w99]e'

call Quit()
