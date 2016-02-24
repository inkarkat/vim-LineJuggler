" Test visual mode repeat of exchanging current line with three down.

runtime plugin/visualrepeat.vim

execute '12normal w3]E'
18normal .

call Quit()
