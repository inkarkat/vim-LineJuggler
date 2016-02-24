" Test fetching number of selected lines 2 up.
" Tests that the cursor moves to the last new line and moves to column 1.

setlocal nofoldenable
execute '7normal Vkw3]f'

call Quit()
