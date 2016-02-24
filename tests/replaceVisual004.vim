" Test replacing visual selection 2 down from the opposite end.
" Tests that the cursor moves to the last replaced line and moves to column 1.

setlocal nofoldenable
execute '4normal Vkw3[r'

call Quit()
