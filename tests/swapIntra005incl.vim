" Test swapping characterwise selection with shorter line.
" Tests that the virtual column is kept and space-padding is added.

set selection=inclusive

15normal zv$viw3[E
call Mark(1)

call setline(18, "18\t\<C-s>INGLE \<C-l>INE")
16normal zv$viw2]E
call Quit(1)
