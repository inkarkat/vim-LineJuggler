" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - ingowindow.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	17-Jul-2012	Add more LineJuggler#Visual...() functions to
"				handle the distance in a visual selection in a
"				uniform way.
"				Implement line swap.
"				FIX: Due to ingowindow#RelativeWindowLine(),
"				a:address is now -1 when addressing a line
"				outside the buffer; adapt the beep / move to
"				border logic, and make it handle current folded
"				line, too.
"				Extract s:Replace() from s:DoSwap() and properly
"				handle replacement at the end of the buffer,
"				when a:startLnum becomes invalid after the
"				temporary delete.
"	001	12-Jul-2012	file creation
let s:save_cpo = &cpo
set cpo&vim

function! LineJuggler#FoldClosed( ... )
    let l:lnum = (a:0 ? a:1 : line('.'))
    return foldclosed(l:lnum) == -1 ? l:lnum : foldclosed(l:lnum)
endfunction
function! LineJuggler#FoldClosedEnd( ... )
    let l:lnum = (a:0 ? a:1 : line('.'))
    return foldclosedend(l:lnum) == -1 ? l:lnum : foldclosedend(l:lnum)
endfunction

function! LineJuggler#BlankUp( address, count ) abort
    execute a:address . 'put! =repeat(nr2char(10), a:count)'
    ']+1
    silent! call       repeat#set("\<Plug>(LineJugglerBlankUp)", a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerBlankUp)", a:count)
endfunction
function! LineJuggler#BlankDown( address, count ) abort
    execute a:address . 'put =repeat(nr2char(10), a:count)'
    '[-1
    silent! call       repeat#set("\<Plug>(LineJugglerBlankDown)", a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerBlankDown)", a:count)
endfunction

function! LineJuggler#Move( range, address, count, direction, mapSuffix ) abort
    " Beep when already on the first / last line, but allow an arbitrary large
    " count to move to the first / last line.
    let l:address = a:address
    if l:address < 0
	if a:direction == -1
	    if LineJuggler#FoldClosed() == 1
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    else
		let l:address = 0
	    endif
	else
	    if LineJuggler#FoldClosedEnd() == line('$')
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    else
		let l:address = line('$')
	    endif
	endif
    endif

    normal! m`
    execute a:range . 'move' l:address
    normal! g``

    silent! call       repeat#set("\<Plug>(LineJugglerMove" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerMove" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#VisualMove( direction, mapSuffix ) abort
    let l:count = v:count1
    " With :<C-u>, we're always in the first line of the selection. To get the
    " actual line of the cursor, we need to leave the visual selection. We
    " cannot do that initially before invoking this function, since then the
    " [count] would be lost. So do this now to get the current line.
    execute "normal! gv\<C-\>\<C-n>"

    let l:targetLnum = ingowindow#RelativeWindowLine(line('.'), l:count, a:direction) - (a:direction == -1 ? 1 : 0)
    call LineJuggler#Move(
    \   "'<,'>",
    \   l:targetLnum,
    \   l:count,
    \   a:direction,
    \   a:mapSuffix
    \)
endfunction

function! s:Replace( startLnum, endLnum, lines )
    silent execute printf('%s,%sdelete _', a:startLnum, a:endLnum)
    if a:startLnum == line('$') + 1
	silent execute (a:startLnum - 1) . 'put =a:lines'
    else
	silent execute a:startLnum . 'put! =a:lines'
    endif
endfunction
function! s:DoSwap( sourceStartLnum, sourceEndLnum, targetStartLnum, targetEndLnum )
    if  a:sourceStartLnum <= a:targetStartLnum && a:sourceEndLnum >= a:targetStartLnum ||
    \   a:targetStartLnum <= a:sourceStartLnum && a:targetEndLnum >= a:sourceStartLnum
	throw 'LineJuggler: overlap in the ranges to swap'
    endif

    let l:sourceLines = getline(a:sourceStartLnum, a:sourceEndLnum)
    let l:targetLines = getline(a:targetStartLnum, a:targetEndLnum)

    call s:Replace(a:sourceStartLnum, a:sourceEndLnum, l:targetLines)

    let l:offset = (a:sourceEndLnum <= a:targetStartLnum ? len(l:targetLines) - len(l:sourceLines) : 0)
    call s:Replace(a:targetStartLnum + l:offset, a:targetEndLnum + l:offset, l:sourceLines)
endfunction
function! LineJuggler#Swap( startLnum, endLnum, address, count, direction, mapSuffix ) abort
    " Beep when already on the first / last line, but allow an arbitrary large
    " count to move to the first / last line.
    let l:address = a:address
    if l:address < 0
	if a:direction == -1
	    if LineJuggler#FoldClosed() == 1
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    else
		let l:address = 1
	    endif
	else
	    if LineJuggler#FoldClosedEnd() == line('$')
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return
	    else
		let l:address = line('$')
	    endif
	endif
    endif

    let [l:targetStartLnum, l:targetEndLnum] = (foldclosed(l:address) == -1 ?
    \   [l:address, l:address + a:endLnum - a:startLnum] :
    \   [foldclosed(l:address), foldclosedend(l:address)]
    \)

    try
	call s:DoSwap(a:startLnum, a:endLnum, l:targetStartLnum, l:targetEndLnum)
    catch /^LineJuggler:/
	let v:errmsg = substitute(v:exception, '^LineJuggler:\s*', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    endtry

    silent! call       repeat#set("\<Plug>(LineJugglerSwap" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerSwap" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#VisualSwap( direction, mapSuffix ) abort
    let l:count = v:count1
    " With :<C-u>, we're always in the first line of the selection. To get the
    " actual line of the cursor, we need to leave the visual selection. We
    " cannot do that initially before invoking this function, since then the
    " [count] would be lost. So do this now to get the current line.
    execute "normal! gv\<C-\>\<C-n>"

    let l:targetLnum = ingowindow#RelativeWindowLine(line('.'), l:count, a:direction)
    call LineJuggler#Swap(
    \   line("'<"), line("'>"),
    \   l:targetLnum,
    \   l:count,
    \   a:direction,
    \   a:mapSuffix
    \)
endfunction

function! LineJuggler#Dup( insLnum, lines, isUp, offset, count, mapSuffix ) abort
    if type(a:lines) == type([]) && len(a:lines) > 1 && empty(a:lines[-1])
	" XXX: Vim omits an empty last element when :put'ting a List of lines.
	" We can work around that by putting a newline character instead.
	let a:lines[-1] = "\n"
    endif

    if a:isUp
	let l:lnum = max([0, a:insLnum - a:offset + 1])
	execute l:lnum . 'put! =a:lines'
    else
	let l:lnum = min([line('$'), a:insLnum + a:offset - 1])
	execute l:lnum . 'put =a:lines'
    endif

    silent! call       repeat#set("\<Plug>(LineJugglerDup" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerDup" . a:mapSuffix . ')', a:count)
endfunction

function! LineJuggler#VisualDupFetch( direction, mapSuffix ) abort
    let l:count = v:count1
    " With :<C-u>, we're always in the first line of the selection. To get the
    " actual line of the cursor, we need to leave the visual selection. We
    " cannot do that initially before invoking this function, since then the
    " [count] would be lost. So do this now to get the current line.
    execute "normal! gv\<C-\>\<C-n>"

    let l:targetStartLnum = ingowindow#RelativeWindowLine(line('.'), l:count, a:direction, -1)
    let l:lines = getline(l:targetStartLnum, l:targetStartLnum + line("'>") - line("'<"))

    silent execute "'<,'>delete" v:register

    call LineJuggler#Dup(
    \   line("'<"),
    \   l:lines,
    \   0, 0,
    \   l:count,
    \   a:mapSuffix
    \)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
