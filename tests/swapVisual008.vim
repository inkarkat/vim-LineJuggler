" Test exchanging visual selection to text up running over a closed fold.
" Tests that the closed fold counts as one line and is swapped in full, as well
" as the next line.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '11normal Vkkw5[E'

call Quit()
