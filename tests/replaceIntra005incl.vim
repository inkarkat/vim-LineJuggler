" Test replacing characterwise selection with shorter line.
" Tests that as much as available is taken.

set selection=inclusive

15normal zv2wv3E5]r
call Mark(1)

call setline(18, "18\t\<C-s>INGLE \<C-l>INE")
16normal zv2wv2El2[r
call Quit(1)
