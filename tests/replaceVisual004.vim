" Test fetching visual selection 2 down from the opposite end.
" Tests that the cursor moves to the new line and moves to column 1.

setlocal nofoldenable
execute '4normal Vkw3[f'

call Quit()
