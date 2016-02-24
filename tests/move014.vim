" Test moving second to last line one down.
" Tests that the cursor moves with the line and moves to column 1.

execute '$-1normal w]e'

call Quit()
