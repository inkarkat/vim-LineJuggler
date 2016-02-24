" Test moving characterwise selection up into fold.
" Tests that the last line of the fold is the move target.

set selection=inclusive

10normal wwve3[e

" Tests that the fold is opened.
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(foldclosed('.'), -1, 'no closed fold at target line')

call Quit(1)
