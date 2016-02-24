" Test exchanging visual selection 2 down from the opposite end.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '4normal Vkw3]E'

call Quit()
