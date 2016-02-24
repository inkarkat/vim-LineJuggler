" Test fetching number of selected lines down from overlapping out of the selection.
" Overlapping into the selection is not possible with fetch down.
" Tests that the cursor moves to the last new line and moves to column 1.

execute '11normal Vkkw[f'

call Quit()
