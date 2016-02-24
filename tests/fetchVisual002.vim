" Test fetching number of selected lines 2 down.
" Tests that the cursor moves to the last new line and moves to column 1.

setlocal nofoldenable
execute '3normal Vjw2[f'

call Quit()
