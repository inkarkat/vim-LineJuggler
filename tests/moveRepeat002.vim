" Test visual mode repeat of moving current line three down.

runtime plugin/visualrepeat.vim

execute '12normal w3]e'
9normal Vj.

call Quit()
