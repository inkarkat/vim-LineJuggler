" Test visual mode repeat of replacing with three lines down.

runtime plugin/visualrepeat.vim

execute '12normal w3[r'
9normal Vj.

call Quit()
