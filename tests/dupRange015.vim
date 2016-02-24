" Test clipping of a large count at the end of the buffer.
" (This cannot happen at the begin, because the count always adds to the current
" line.)
" Tests that the cursor moves with the line and moves to column 1.

execute '29normal w99]D'

call Quit()
