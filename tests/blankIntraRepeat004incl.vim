" Test normal mode repeat of inserting characterwise blanks at another position.

set selection=inclusive

execute '10normal wwve3] '
12normal ee.

call Quit(1)
