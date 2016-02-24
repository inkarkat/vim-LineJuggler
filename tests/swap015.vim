" Test exchange clipping of a large count to the first line.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '6normal znwzN99[E'

call Quit()
