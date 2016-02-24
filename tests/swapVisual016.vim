" Test exchanging visual selection clipping to the last line.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '10normal Vjjw99]E'

call Quit()
