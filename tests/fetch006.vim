" Test fetching one line with 3 up across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor moves to the new line and moves to column 1.

execute '5normal w3]f'

call Quit()
