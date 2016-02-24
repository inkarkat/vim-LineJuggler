" Test replacing first line one up on repeat.
" Tests that nothing happens (except for a beep).
" Tests that the cursor stays.

set selection=exclusive

10normal wwve99]r
1normal .

call Quit(1)
