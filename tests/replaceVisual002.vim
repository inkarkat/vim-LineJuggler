" Test replacing visual selection 2 down.
" Tests that the cursor moves to the last replaced line and moves to column 1.

setlocal nofoldenable
execute '3normal Vjw2[r'

call Quit()
