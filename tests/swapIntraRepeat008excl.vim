" Test swapping last line one down on repeat.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

set selection=exclusive

10normal wwve99]E
normal .

call Quit(1)
