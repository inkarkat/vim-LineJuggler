" ingolines.vim: Custom line manipulation.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	16-Aug-2012	file creation from LineJuggler.vim autoload
"				script.

function! ingolines#PutWrapper( lnum, putCommand, lines )
    if v:version < 703 || v:version == 703 && ! has('patch272')
	" Fixed by 7.3.272: ":put =list" does not add empty line for trailing
	" empty item
	if type(a:lines) == type([]) && len(a:lines) > 1 && empty(a:lines[-1])
	    " XXX: Vim omits an empty last element when :put'ting a List of lines.
	    " We can work around that by putting a newline character instead.
	    let a:lines[-1] = "\n"
	endif
    endif

    silent execute a:lnum . a:putCommand '=a:lines'
endfunction
function! ingolines#PutBefore( lnum, lines )
    if a:lnum == line('$') + 1
	call ingolines#PutWrapper((a:lnum - 1), 'put',  a:lines)
    else
	call ingolines#PutWrapper(a:lnum, 'put!',  a:lines)
    endif
endfunction
function! ingolines#Replace( startLnum, endLnum, lines, ... )
    silent execute printf('%s,%sdelete %s', a:startLnum, a:endLnum, (a:0 ? a:1 : '_'))
    call ingolines#PutBefore(a:startLnum, a:lines)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
