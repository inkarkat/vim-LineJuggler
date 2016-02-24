" Test that mappings keep the contents of the expression register.

call vimtest#StartTap()
call vimtap#Plan(5)

execute "1normal! I\<C-r>=v:version\<CR>\<Esc>"
call vimtap#Is(@=, 'v:version', 'original expression')

execute '12normal w[ '
call vimtap#Is(@=, 'v:version', 'same expression after [<Space>')

execute '12normal w3[e'
call vimtap#Is(@=, 'v:version', 'same expression after 3[e')

execute '18normal w]d'
call vimtap#Is(@=, 'v:version', 'same expression after ]d')

execute '26normal w2[E'
call vimtap#Is(@=, 'v:version', 'same expression after 2[E')

call vimtest#Quit()
