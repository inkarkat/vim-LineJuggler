" Test exchanging visual selection to directly adjacent text up.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

execute '12normal Vkw2[E'

call Quit()
