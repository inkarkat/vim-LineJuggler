" Test replacing folded single-line visual selection down.
" Tests that the selection is counted as one line, not the number of contained
" lines.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '15normal V2]r'

call Quit()
