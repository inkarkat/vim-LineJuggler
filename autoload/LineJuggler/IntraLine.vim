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
"   2.00.006	12-Nov-2013	Implement characterwise selection blank with
"				[<Space>, ]<Space>.
"				FIX: Must not apply "l" correction for "gv".
"				Factor out s:NeedSelectionCorrection() and split
"				the command sequence in s:Repeat() into
"				individual steps.
"   2.00.005	11-Nov-2013	Implement characterwise selection swap with [E,
"				]E.
"				Implement characterwise selection fetch and
"				replace with [r, ]r.
"				Factor out intra-repeat into s:Repeat().
"   2.00.004	30-Oct-2013	Move the repeated normal mode repeat logic here.
"   2.00.003	29-Oct-2013	Extract generic s:Dup() and implement
"				LineJuggler#IntraLine#DupRange() with it, too.
"				Implement repeat of intra-line mappings.
"   2.00.002	28-Oct-2013	Finish implementation of
"				LineJuggler#IntraLine#Dup().
"   2.00.001	27-Oct-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:NeedSelectionCorrection()
    return (&selection ==# 'exclusive' && col('.') < col('$'))
endfunction
function! s:Repeat( samePositionReselectCommand, Func, ... )
    if foldclosed('.') != -1
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return
    endif

    let l:save_cursor = getpos('.')
    let l:reselectCommand = (getpos('.') == getpos("']") ? a:samePositionReselectCommand : '1v')
    execute 'normal!' l:reselectCommand
    if l:reselectCommand =~# '1v$' && s:NeedSelectionCorrection()
	normal! l
    endif
    execute "normal! \<Esc>"

    if ! call(a:Func, a:000)
	" The correction for exclusive selection must be undone when no move was
	" possible to keep the cursor in place.
	call setpos('.', l:save_cursor)
    endif
endfunction
function! s:RepeatSet( what, count, mapSuffix )
    " To repeat the intra-line mappings, we need special normal mode mappings
    " that first re-establish the previous visual selection.
    silent! call       repeat#set("\<Plug>(LineJuggler" . a:what . 'Intra' . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJuggler" . a:what           . a:mapSuffix . ')', a:count)
endfunction
function! s:IsInclusiveSelection()
    return (&selection !=# 'exclusive' || col("'>") == col('$') && &virtualedit !~# 'all\|onemore')
endfunction

function! LineJuggler#IntraLine#Blank( direction, count, mapSuffix )
    let l:command = (a:direction == -1 ? 'g`<P' : 'g`>' . (&selection ==# 'exclusive' ? 'P' : 'p'))
    let l:save_virtualedit = &virtualedit
    set virtualedit=onemore
    try
	call ingo#register#KeepRegisterExecuteOrFunc(printf('let @" = repeat(" ", %d) | normal! %s', (a:count ? a:count : 1), l:command))
    finally
	let &virtualedit = l:save_virtualedit
    endtry

    call s:RepeatSet('Blank', a:count, a:mapSuffix)
    return 1
endfunction
function! LineJuggler#IntraLine#BlankRepeat( direction, count, mapSuffix )
    if foldclosed('.') != -1
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return
    endif

    " Don't clobber the existing visual selection; just add the blanks at the
    " current cursor position.
    let l:command = (a:direction == -1 ? 'P' : 'p')
    call ingo#register#KeepRegisterExecuteOrFunc(printf('let @" = repeat(" ", %d) | normal! %s', (a:count ? a:count : 1), l:command))

    call s:RepeatSet('Blank', a:count, a:mapSuffix)
    return 1
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
    return 1
endfunction
function! LineJuggler#IntraLine#Dup( direction, offset, mapSuffix )
    return s:Dup(a:direction, a:offset, 0, a:offset, a:mapSuffix)
endfunction
function! LineJuggler#IntraLine#DupRange( direction, repeat, mapSuffix )
    return s:Dup(a:direction, 0, a:repeat, a:repeat, a:mapSuffix)
endfunction
function! LineJuggler#IntraLine#DupRepeat( DupFunc, ... )
    call call('s:Repeat', ['gv', a:DupFunc] + a:000)
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
    call s:Repeat('g`[1v', function('LineJuggler#VisualMove'), a:direction, a:count, a:mapSuffix)
endfunction

function! s:RestoreOriginalSelection( originalSelection )
    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.

    call setpos("'<", a:originalSelection[0])
    call setpos("'>", a:originalSelection[1])
    call setpos('.', a:originalSelection[2])
endfunction
function! s:YankSource( address, originalSelection )
    let @" = ''
    let l:virtcol = virtcol("'<")
    let l:positioning = printf('%dG%d|', a:address, l:virtcol)
    execute 'silent keepjumps normal!' l:positioning . 'zv1v'
    if virtcol('.') < l:virtcol
	" Not enough text to make a selection.
	call s:RestoreOriginalSelection(a:originalSelection)
	return 0
    elseif s:NeedSelectionCorrection()
	normal! l
    endif
    normal! y
    if empty(@")
	" Nothing yanked.
	call s:RestoreOriginalSelection(a:originalSelection)
	return 0
    else
	return 1
    endif
endfunction
function! LineJuggler#IntraLine#DoSwap( address )
    let l:originalSelection = [getpos("'<"), getpos("'>"), getpos('.')]
    if ! s:YankSource(a:address, l:originalSelection)
	return
    endif
    let l:targetSelection = [getpos("'<"), getpos("'>")]

    call setpos("'<", l:originalSelection[0])
    call setpos("'>", l:originalSelection[1])
    silent keepjumps normal! gvp

    call setpos("'<", l:targetSelection[0])
    call setpos("'>", l:targetSelection[1])
    silent keepjumps normal! gvp

    call setpos("'<", l:originalSelection[0])
    call setpos("'>", l:originalSelection[1])
endfunction
function! LineJuggler#IntraLine#Swap( direction, address, count, mapSuffix )
    let l:address = LineJuggler#ClipAddress(a:address, a:direction, 1)
    if l:address == -1 | return 0 | endif

    let l:save_virtualedit = &virtualedit
    set virtualedit=all
    try
	call ingo#register#KeepRegisterExecuteOrFunc(function('LineJuggler#IntraLine#DoSwap'), [l:address])
    finally
	let &virtualedit = l:save_virtualedit
    endtry

    call s:RepeatSet('Swap', a:count, a:mapSuffix)
    return 1
endfunction
function! LineJuggler#IntraLine#SwapRepeat( direction, count, mapSuffix )
    call s:Repeat('g`[1v', function('LineJuggler#VisualSwap'), a:direction, a:count, a:mapSuffix)
endfunction

function! LineJuggler#IntraLine#DoRepFetch( address )
    let l:originalSelection = [getpos("'<"), getpos("'>"), getpos('.')]
    if ! s:YankSource(a:address, l:originalSelection)
	return
    endif

    " When the source line is shorter than the selection, we may have captured
    " the newline, too.
    let @" = substitute(@", '\n$', '', '')

    call setpos("'<", l:originalSelection[0])
    call setpos("'>", l:originalSelection[1])
    silent keepjumps normal! gvp
    call setpos("'>", l:originalSelection[1])   " With selection=exclusive, the paste moves the selection end one left.
endfunction
function! LineJuggler#IntraLine#RepFetch( direction, address, count, mapSuffix )
    let l:address = LineJuggler#ClipAddress(a:address, a:direction, 1)
    if l:address == -1 | return 0 | endif

    let l:positioning = printf('%dG%d|', l:address, virtcol("'<"))
    call ingo#register#KeepRegisterExecuteOrFunc(function('LineJuggler#IntraLine#DoRepFetch'), [l:address])

    call s:RepeatSet('RepFetch', a:count, a:mapSuffix)
    return 1
endfunction
function! LineJuggler#IntraLine#RepFetchRepeat( direction, count, mapSuffix )
    call s:Repeat('1v', function('LineJuggler#VisualRepFetch'), a:direction, a:count, a:mapSuffix)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
