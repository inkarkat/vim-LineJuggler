" Test visual mode repeat of duplicating three lines down.

runtime plugin/visualrepeat.vim

execute '12normal w3]D'
9normal Vj.

call Quit()
