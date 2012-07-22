" Test fetching visual selection to directly adjacent text down.
" Tests that the cursor moves to the new line and moves to column 1.

execute '9normal Vjw[f'

call Quit()
