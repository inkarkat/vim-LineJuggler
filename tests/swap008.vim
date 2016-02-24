" Test exchanging folded line with same amount of lines down.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

execute '6normal znwzN2]E'

call Quit()
