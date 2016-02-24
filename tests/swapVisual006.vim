" Test exchanging visual selection to directly adjacent text down.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '9normal Vjw]E'

call Quit()
