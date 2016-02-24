" Test normal mode repeat of fetching two lines up.
" Tests that the cursor moves to the new line and moves to column 1.

execute '12normal w2]f'
10normal .

call Quit()
