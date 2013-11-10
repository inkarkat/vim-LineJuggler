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
"   1.30.004	30-Oct-2013	Move the repeated normal mode repeat logic here.
"   1.30.003	29-Oct-2013	Extract generic s:Dup() and implement
"				LineJuggler#IntraLine#DupRange() with it, too.
"				Implement repeat of intra-line mappings.
"   1.30.002	28-Oct-2013	Finish implementation of
"				LineJuggler#IntraLine#Dup().
"   1.30.001	27-Oct-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:RepeatSet( what, count, mapSuffix )
    " To repeat the intra-line mappings, we need special normal mode mappings
    " that first re-establish the previous visual selection.
    silent! call       repeat#set("\<Plug>(LineJuggler" . a:what . 'Intra' . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJuggler" . a:what           . a:mapSuffix . ')', a:count)
endfunction
function! s:IsInclusiveSelection()
    return (&selection !=# 'exclusive' || col("'>") == col('$') && &virtualedit !~# 'all\|onemore')
endfunction

function! s:Dup( direction, offset, repeat, count, mapSuffix )
    let l:repeat = (a:repeat ? a:repeat : '')
    if a:offset
	let l:offset = a:offset . (a:direction == -1 ? 'h' : 'l')
	if a:direction == -1
	    " Up direction is easy: after the yank, the cursor is at the
	    " beginning, and one can always just paste before.
	    let l:positioning = l:offset
	    let l:paste = 'P'
	elseif s:IsInclusiveSelection()
	    " Down direction with inclusive selection needs to go to the end of
	    " the selection first. Same for the special case of exclusive
	    " selection, but ending at the end of the line.
	    let l:positioning = 'g`>' . l:offset
	    let l:paste = 'p'
	else
	    " Down direction with exclusive selection in the usual case needs to
	    " account for the cursor already being one beyond the selection.
	    let l:positioning = 'g`>' . (a:offset > 1 ? (a:offset - 1) . 'l' : '')
	    let l:paste = 'p'
	endif
    else
	if a:direction == -1
	    let l:positioning = ''
	    let l:paste =  'P'
	else
	    let l:positioning = 'g`>'
	    let l:paste =  (s:IsInclusiveSelection() ? 'p' : 'P')
	endif
    endif
"****D echomsg '****' string(l:paste)
    " h and l must not move to different lines, we want an offset overflow to go
    " to the border of the current line.
    let l:save_whichwrap = &whichwrap
    set whichwrap=
    try
	call ingo#register#KeepRegisterExecuteOrFunc('silent normal! gvy' . l:positioning . l:repeat . l:paste)
    finally
	let &whichwrap = l:save_whichwrap
    endtry

    call s:RepeatSet('Dup', a:count, a:mapSuffix)
endfunction
function! LineJuggler#IntraLine#Dup( direction, offset, mapSuffix )
    call s:Dup(a:direction, a:offset, 0, a:offset, a:mapSuffix)
endfunction
function! LineJuggler#IntraLine#DupRange( direction, repeat, mapSuffix )
    call s:Dup(a:direction, 0, a:repeat, a:repeat, a:mapSuffix)
endfunction
function! LineJuggler#IntraLine#DupRepeat( DupFunc, ... )
    if foldclosed('.') != -1
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return
    endif

    execute 'normal!' (getpos('.') == getpos("']") ? 'gv' : '1v' . (&selection ==# 'exclusive' ? 'l' : '')) . "\<Esc>"
    call call(a:DupFunc, a:000)
endfunction

function! LineJuggler#IntraLine#Move( direction, address, count, mapSuffix )
    let l:address = LineJuggler#ClipAddress(a:address, a:direction, 1)
    if l:address == -1 | return 0 | endif

    let l:positioning = printf('%dG%d|', l:address, virtcol("'<"))
    let l:save_virtualedit = &virtualedit
    set virtualedit=all
    try
	call ingo#register#KeepRegisterExecuteOrFunc('silent keepjumps normal! gvd' . l:positioning . 'zvP')
    finally
	let &virtualedit = l:save_virtualedit
    endtry

    call s:RepeatSet('Move', a:count, a:mapSuffix)
    return 1
endfunction
function! LineJuggler#IntraLine#MoveRepeat( direction, count, mapSuffix )
    if foldclosed('.') != -1
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return
    endif

    let l:save_cursor = getpos('.')
    execute 'normal!' (getpos('.') == getpos("']") ? 'g`[' : '') . '1v' . (&selection ==# 'exclusive' ? 'l' : '') . "\<Esc>"
    if ! LineJuggler#VisualMove(a:direction, a:count, a:mapSuffix)
	" The correction for exclusive selection must be undone when no move was
	" possible to keep the cursor in place.
	call setpos('.', l:save_cursor)
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
