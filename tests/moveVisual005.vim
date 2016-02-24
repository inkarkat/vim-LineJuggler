" Test moving the visual selection up into itself.
" Tests that nothing happens (except for a beep).
" Tests that an error is printed.

execute '10normal Vjjw[e'

call Quit()
