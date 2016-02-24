" Test fetching number of selected lines up from overlapping into the selection.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '9normal Vjjw3]f'

call Quit()
