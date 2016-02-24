" Test visual mode repeat of fetching three lines down.
" Tests that the original (not the adapted) count is used.

runtime plugin/visualrepeat.vim

execute '12normal w3[f'
10normal Vj.

call Quit()
