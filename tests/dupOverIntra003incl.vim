" Test duplicating characterwise selection directly down at the end of the line.

set selection=inclusive

execute '10normal $viw]d'

call Quit(1)
