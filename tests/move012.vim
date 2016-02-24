" Test moving last line one down.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '$normal w]e'

call Quit()
