" Test duplicating visual selection down from the opposite end.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '4normal Vkw]D'

call Quit()
