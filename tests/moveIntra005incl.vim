" Test moving characterwise selection into shorter line.
" Tests that the virtual column is kept and space-padding is added.

set selection=inclusive

15normal zv$viw3[e
call Mark(1)

call setline(18, "18\t\<C-s>INGLE \<C-l>INE")
16normal zv$viw2]e
call Quit(1)
