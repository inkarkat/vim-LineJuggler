" Test normal mode repeat of inserting blank line after selection.

execute '12normal w2] '
10normal .

call Quit()
