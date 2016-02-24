" Test replacing visual selection 2 up.
" Tests that the cursor moves to the last replaced line and moves to column 1.

setlocal nofoldenable
execute '7normal Vkw3]r'

call Quit()
