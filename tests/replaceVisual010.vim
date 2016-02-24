" Test replacing visual selection clipping to the first line.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '12normal Vkkw99]r'

call Quit()
