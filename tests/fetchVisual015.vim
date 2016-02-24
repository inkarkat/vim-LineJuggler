" Test fetching number of selected lines clipping from up.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '12normal Vkw99]f'

call Quit()
