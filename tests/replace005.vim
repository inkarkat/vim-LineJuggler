" Test replacing with one line 3 up across a fold.
" Tests that the closed fold is counted as one line.
" Tests that the cursor stays in the current line and moves to column 1.

execute '5normal w3]r'

call Quit()
