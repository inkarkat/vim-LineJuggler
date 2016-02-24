" Test normal mode repeat of swapping characterwise selection from a closed fold.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

set selection=inclusive

10normal wwve3]E
14normal .

call Quit(1)
