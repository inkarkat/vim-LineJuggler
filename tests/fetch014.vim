" Test fetching a folded line up.
" Tests that the closed fold counts as one line and is fetched in full.
" Tests that the cursor moves to the new line and moves to column 1.

execute '12normal w5]f'

call Quit()
