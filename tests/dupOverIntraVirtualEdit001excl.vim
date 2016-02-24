" Test duplicating characterwise selection directly, counting, and overflowing down to end with virtualedit=onemore.

set selection=exclusive virtualedit=onemore

10normal V2]D
10normal $viw]d
call Mark(1)
11normal wwve11]d
call Mark(1)
12normal wwve99]d

call Quit(1)
