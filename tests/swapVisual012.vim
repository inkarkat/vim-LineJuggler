" Test exchanging visual selection to overlapping lines.
" Tests that nothing happens (except for a beep).
" Tests that an error is printed.

execute '11normal Vkkw2]E'

call Quit()
