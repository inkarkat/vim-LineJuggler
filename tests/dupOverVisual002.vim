" Test duplicating visual selection across 2 down.
" Tests that the cursor moves to the last duplicated line and to column 1.

execute '9normal Vjjw2]d'

call Quit()
