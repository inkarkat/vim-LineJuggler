" Test exchanging last line down.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '$normal w]E'

call Quit()
