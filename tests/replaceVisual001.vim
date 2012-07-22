" Test fetching visual selection 2 up.
" Tests that the cursor moves to the new line and moves to column 1.

setlocal nofoldenable
execute '7normal Vkw3]f'

call Quit()
