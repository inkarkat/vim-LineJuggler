" Test moving characterwise selection down into fold.
" Tests that the first line of the fold is the move target.

set selection=exclusive

10normal wwve4]e

" Tests that the fold is opened.
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(foldclosed('.'), -1, 'no closed fold at target line')

call Quit(1)
