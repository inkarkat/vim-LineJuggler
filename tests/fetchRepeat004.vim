" Test normal mode repeat of repeatedly fetching down.
" Tests that subsequent lines are fetched (also considering folds).

execute '10normal w8[f'
normal .
normal .
normal .
normal .

call Quit()
