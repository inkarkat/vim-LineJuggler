" Test exchanging visual selection 2 up.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

setlocal nofoldenable
execute '7normal Vkw3[E'

call Quit()
