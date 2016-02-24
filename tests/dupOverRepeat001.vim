" Test normal mode repeat of duplicating current line two up.

execute '12normal w2[d'
9normal .

call Quit()
