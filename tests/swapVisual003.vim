" Test exchanging visual selection 2 up from the opposite end.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

setlocal nofoldenable
execute '6normal Vjw4[E'

call Quit()
