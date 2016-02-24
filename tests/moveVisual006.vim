" Test moving the visual selection down into itself.
" Tests that nothing happens (except for a beep).
" Tests that an error is printed.

execute '12normal Vkkw]e'

call Quit()
