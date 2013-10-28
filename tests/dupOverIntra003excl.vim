" Test duplicating characterwise selection directly down at the end of the line.

set selection=exclusive

execute '10normal $viw]d'

call Quit(1)
