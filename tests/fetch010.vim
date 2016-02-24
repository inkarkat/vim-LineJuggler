" Test fetching from above first line.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '1normal w]f'

call Quit()
