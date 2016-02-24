" Test replacing characterwise selection with too short line.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

set selection=inclusive

15normal zv$viw4]r

call Quit(1)
