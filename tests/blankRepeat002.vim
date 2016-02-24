" Test visual mode repeat of inserting blank line before selection.

runtime plugin/visualrepeat.vim

execute '12normal w3[ '
10normal Vj.

call Quit()
