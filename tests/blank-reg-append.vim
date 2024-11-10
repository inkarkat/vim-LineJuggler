" Test appending blank line to register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call vimtest#StartTap()
call vimtap#Plan(4)

let @a = "two\nlines\n"
execute 'normal "a] '
call vimtap#Is(@a, "two\nlines\n\n", 'prepending blank line to linewise register')
let @a = "two\nlines\n"
execute 'normal "a3] '
call vimtap#Is(@a, "two\nlines\n\n\n\n", 'prepending three blank lines to linewise register')

let @b = 'characterwise contents'
execute 'normal "b] '
call vimtap#Is(@b, "characterwise contents\n", 'prepending blank line to characterwise register makes it linewise')

let @b = 'characterwise contents'
execute 'normal "b3] '
call vimtap#Is(@b, "characterwise contents\n\n\n", 'prepending three blank lines to characterwise register adds two blank lines')

call vimtest#Quit()
