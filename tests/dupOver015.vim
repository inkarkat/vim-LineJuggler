" Test clipping of a large count to the first line.
" Tests that the cursor moves with the line and moves to column 1.

execute '12normal w99[d'

call Quit()