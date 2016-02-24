" Test exchanging folded single-line visual selection up.
" Tests that the selection is counted as one line, not the number of contained
" lines.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '15normal V5[E'

call Quit()
