" Test replacing visual selection 2 up from the opposite end.
" Tests that the cursor moves to the last replaced line and moves to column 1.

setlocal nofoldenable
execute '6normal Vjw4]r'

call Quit()
