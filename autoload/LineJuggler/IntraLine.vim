" LineJuggler/IntraLine.vim: Duplicate and move inside a single line.
"
" DEPENDENCIES:
"   - ingo/register.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	28-Oct-2013	Finish implementation of
"				LineJuggler#IntraLine#Dup().
"	001	27-Oct-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:IsInclusiveSelection()
    return (&selection !=# 'exclusive' || col("'>") == col('$') && &virtualedit !~# 'all\|onemore')
endfunction
function! LineJuggler#IntraLine#Dup( direction, count, mapSuffix )
    if a:count
	let l:offset = a:count . (a:direction == -1 ? 'h' : 'l')
	if a:direction == -1
	    " Up direction is easy: after the yank, the cursor is at the
	    " beginning, and one can always just paste before.
	    let l:paste = l:offset . 'P'
	elseif s:IsInclusiveSelection()
	    " Down direction with inclusive selection needs to go to the end of
	    " the selection first. Same for the special case of exclusive
	    " selection, but ending at the end of the line.
	    let l:paste = 'g`>' . l:offset . 'p'
	else
	    " Down direction with exclusive selection in the usual case needs to
	    " account for the cursor already being one beyond the selection.
	    let l:paste = 'g`>' . (a:count > 1 ? (a:count - 1) . 'l' : '') . 'p'
	endif
    else
	let l:paste = (a:direction == -1 ?
	\   'P' :
	\   'g`>' . (s:IsInclusiveSelection() ? 'p' : 'P')
	\)
    endif
"****D echomsg '****' string(l:paste)
    " h and l must not move to different lines, we want a count overflow to go
    " to the border of the current line.
    let l:save_whichwrap = &whichwrap
    set whichwrap=
    try
	call ingo#register#KeepRegisterExecuteOrFunc('silent normal! gvy' . l:paste)
    finally
	let &whichwrap = l:save_whichwrap
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
