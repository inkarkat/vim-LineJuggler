" Test fetching one line up to below current closed fold.
" Tests that the line is not fetched into, but across the fold.
" Tests that the cursor moves to the new line and moves to column 1.

execute '15normal znwzN]f'

call Quit()
