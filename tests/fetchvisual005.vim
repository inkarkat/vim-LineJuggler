" Test fetching visual selection to directly adjacent text up.
" Tests that the cursor moves to the new line and moves to column 1.

execute '12normal Vkw2]f'

call Quit()
