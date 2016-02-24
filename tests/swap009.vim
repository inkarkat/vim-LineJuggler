" Test exchanging current line with folded lines.
" Tests that the cursor moves with the line and moves to column 1.

21foldopen
execute '25normal w2[E'

call Quit()
