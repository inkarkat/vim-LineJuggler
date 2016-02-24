" Test exchanging visual selection clipping to the first line.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '12normal Vkkw99[E'

call Quit()
