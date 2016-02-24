" Test normal mode repeat of duplicating characterwise selection at another position.

set selection=exclusive

22normal zvwv$]d..
25normal zvw.

call Quit(1)
