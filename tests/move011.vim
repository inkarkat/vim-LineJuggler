" Test moving first line one up.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '1normal w[e'

call Quit()
