" Test duplicating characterwise selection over larger-width characters.

set selection=exclusive virtualedit=

execute '10normal V3]D'
execute '10normal wrlrwve2[d'
call Mark(1)
execute '11normal 3wrlrbbve2]d'
call Mark(1)
execute '12normal eelr	wve1[d'
call Mark(1)
execute '13normal 3elr	bve1]d'

call Quit(1)
