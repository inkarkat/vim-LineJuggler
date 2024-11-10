" Test swapping across a fold marker.

insert
first line

" {{{
     folded

     here
" }}}

last line
.

setlocal foldenable foldmethod=marker foldlevel=1

4normal [E]E

call vimtest#SaveOut()
call vimtest#Quit()
