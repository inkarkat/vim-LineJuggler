" Test fetching number of selected lines 2 down from the opposite end.
" Tests that the cursor moves to the last new line and moves to column 1.

setlocal nofoldenable
execute '4normal Vkw3[f'

call Quit()
