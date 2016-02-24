" Test exchanging current line with 2 up across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves with the line and moves to column 1.

execute '5normal w2[E'

call Quit()
