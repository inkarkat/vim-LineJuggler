" Test exchanging visual selection 2 down.
" Tests that the cursor moves to the end of the original folded lines and moves to column 1.

setlocal nofoldenable
execute '3normal Vjw2]E'

call Quit()
