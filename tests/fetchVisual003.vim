" Test fetching number of selected lines 2 up from the opposite end.
" Tests that the cursor moves to the last new line and moves to column 1.

setlocal nofoldenable
execute '6normal Vjw4]f'

call Quit()
