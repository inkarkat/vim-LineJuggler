" Test normal mode repeat of repeatedly fetching up.
" Tests that subsequent lines are fetched (also considering folds).

execute '10normal w7]f'
normal .
normal .
normal .
normal .
normal .
normal .
normal .

call Quit()
