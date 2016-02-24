" Test visual mode repeat of duplicating current line three down.

runtime plugin/visualrepeat.vim

execute '12normal w3]d'
9normal Vj.

call Quit()
