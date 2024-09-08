" Test prepending blank line to register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call vimtest#StartTap()
call vimtap#Plan(4)

let @a = "two\nlines\n"
execute 'normal "a[ '
call vimtap#Is(@a, "\ntwo\nlines\n", 'prepending blank line to linewise register')
let @a = "two\nlines\n"
execute 'normal "a3[ '
call vimtap#Is(@a, "\n\n\ntwo\nlines\n", 'prepending three blank lines to linewise register')

let @b = 'characterwise contents'
execute 'normal "b[ '
call vimtap#Is(@b, "\ncharacterwise contents", 'prepending blank line to characterwise register')

let @b = 'characterwise contents'
execute 'normal "b3[ '
call vimtap#Is(@b, "\n\n\ncharacterwise contents", 'prepending three blank lines to characterwise register')

call vimtest#Quit()
