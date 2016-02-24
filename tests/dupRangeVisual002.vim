" Test duplicating visual selection down.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '3normal Vjw]D'

call Quit()
