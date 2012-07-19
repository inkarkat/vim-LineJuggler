" Test fetching a folded line down.
" Tests that the closed fold counts as one line and is fetched in full.
" Tests that the cursor moves to the new line and moves to column 1.

execute '12normal w2[f'

call Quit()
