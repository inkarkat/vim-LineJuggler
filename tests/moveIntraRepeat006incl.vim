" Test normal mode repeat of moving characterwise selection from a closed fold.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

set selection=inclusive

10normal wwve3]e
14normal .

call Quit(1)
