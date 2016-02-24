" Test replacing visual selection to directly adjacent text down.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '9normal Vjw[r'

call Quit()
