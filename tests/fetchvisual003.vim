" Test fetching visual selection 2 up from the oppsite end.
" Tests that the cursor moves to the new line and moves to column 1.

setlocal nofoldenable
execute '6normal Vjw4]f'

call Quit()
