" Test moving current line up before closed fold.
" Tests that the line is not moved into, but across the fold.
" Tests that the cursor moves with the line and moves to column 1.

execute '5normal w[e'

call Quit()
