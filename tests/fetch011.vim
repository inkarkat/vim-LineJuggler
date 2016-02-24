" Test fetching from below last line.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '$normal w[f'

call Quit()
