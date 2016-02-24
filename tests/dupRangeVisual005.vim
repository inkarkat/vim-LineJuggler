" Test duplicating visual selection twice up.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '14normal Vjjw2[D'

call Quit()
