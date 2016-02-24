" Test fetching folded single-line visual selection down.
" Tests that the selection is counted as one line, not the number of contained
" lines.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '15normal V2[f'

call Quit()
