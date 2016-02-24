" Test replacing a folded line up.
" Tests that the closed fold counts as one line and all folded lines are
" fetched.
" Tests that the cursor moves to the last replaced line and moves to column 1.

execute '12normal w5]r'

call Quit()
