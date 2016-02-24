" Test duplicating current line up before closed fold.
" Tests that the line is not duplicated into, but before the fold.
" Tests that the cursor moves with the line and moves to column 1.

execute '5normal w[d'

call Quit()
