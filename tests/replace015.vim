" Test replacing a folded line down.
" Tests that the closed fold counts as one line and all folded lines are
" fetched.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '12normal w2[r'

call Quit()
