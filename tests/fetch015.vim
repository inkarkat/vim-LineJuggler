" Test fetching a folded line down.
" Tests that the closed fold counts as one line and all folded lines are
" fetched.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '12normal w2[f'

call Quit()
