" Test replacing visual selection clipping to the last line.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '10normal Vjjw99[r'

call Quit()
