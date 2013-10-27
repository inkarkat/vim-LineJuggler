" LineJuggler/IntraLine.vim: Duplicate and move inside a single line.
"
" DEPENDENCIES:
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	27-Oct-2013	file creation

function! LineJuggler#IntraLine#Dup( direction, count, mapSuffix )
    call ingo#register#KeepRegisterExecuteOrFunc('silent normal! gvy' . (a:direction == -1 ? 'gP' : 'g`>pg`['))
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
