" Test replacing visual selection to directly adjacent text up.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '12normal Vkw2]r'

call Quit()
