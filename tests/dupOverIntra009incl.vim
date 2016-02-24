" Test duplicating characterwise selection down to overflowing end.
" Tests that the cursor moves to the end of the duplicated selection.

set selection=inclusive

10normal wwve99]d

call Quit(1)
