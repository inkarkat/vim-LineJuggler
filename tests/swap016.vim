" Test exchange clipping of a large count to the last line.
" Tests that clipping considers the amount of lines of the source fold and
" subtracts them from the last available line number.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '6normal znwzN99]E'

call Quit()
