" Test fetching number of selected lines clipping from down.
" Tests that the same number of visual lines as selected is fetched from the end
" of the buffer.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '9normal Vjw99[f'

call Quit()
