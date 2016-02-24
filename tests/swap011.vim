" Test exchanging first line up.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

execute '1normal w[E'

call Quit()
