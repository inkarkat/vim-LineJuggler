" Test replacing with one line above current closed fold.
" Tests that the line replaces the entire fold, not just the current line.
" Tests that the cursor stays in the single replaced line and moves to column 1.

execute '15normal znwzN]r'

call Quit()
