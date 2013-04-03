" Test putting a list of lines that end with an empty line.

insert
first line
last line
.

call ingolines#PutWrapper(1, 'put', ['new 1', 'new 2; v empty line here', ''])

call vimtest#SaveOut()
call vimtest#Quit()
