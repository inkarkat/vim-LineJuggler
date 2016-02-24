" Test duplicating visual selection up.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '7normal Vkw[D'

call Quit()
