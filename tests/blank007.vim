" Test inserting blank line before with following line folded.
" Tests that the blank line is inserted between the current and the folded line.
" Tests that the cursor remains on the original line and moves to column 1.

execute '5normal w[ '

call Quit()
