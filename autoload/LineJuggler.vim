" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - ingolines.vim autoload script
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
"   1.21.010	02-Sep-2012	Use ingolines#PutWrapper() also for
"				LineJuggler#Blank() to avoid clobbering the
"				expression register.
"   1.21.009	16-Aug-2012	Factor out s:PutWrapper() and s:Replace() into
"				ingolines.vim autoload script for reuse.
"   1.20.008	27-Jul-2012	CHG: [d / ]d duplication without [count] still
"				duplicates to directly adjacent line, but with
"				[count] now across [count] lines, which aligns
"				with the 'relativenumber' hint. Rename
"				LineJuggler#Dup() to LineJuggler#DupToOffset()
"				for the shared, minimal functionality, and add
"				dedicated new LineJuggler#Dup() /
"				LineJuggler#VisualDup() for the [d / ]d
"				mappings.
"				FIX: Correct clipping at the end for the ]E
"				mapping; must substract relative window line
"				from the end, not just the number of swapped
"				lines.
"				FIX: Make sure that v_[E / v_]E never swap with
"				a single folded target line; this special
"				behavior is reserved for the single-line normal
"				mode swap.
"				CHG: For visual selections in v_[E, v_[f, v_[r,
"				also use the amount of visible lines (determined
"				through ingowindow#NetVisibleLines()), not the
"				number of lines contained in the selection. This
"				makes it more consistent with the overall plugin
"				behavior and is hopefully also more useful.
"				Factor out the common visual re-selection.
"   1.11.007	24-Jul-2012	The workaround in s:PutWrapper() is not
"				necessary after Vim version 7.3.272; add
"				conditional.
"   1.10.006	23-Jul-2012	Extract s:PutWrapper() to apply the "empty last
"				element" workaround consistently to all
"				instances of :put use (which as previously
"				missed for s:Replace()).
"				CHG: Split [f and {Visual}[f behaviors into two
"				families of mappings:
"				a) [f to fetch below current line and {Visual}[f
"				to fetch selected number of lines above/below
"				selection
"				b) [r to fetch and replace current line /
"				selection.
"				The renamed LineJuggler#VisualRepFetch() uses
"				s:RepFetch() instead of the (similar)
"				LineJuggler#Dup() function.
"				s:Replace() takes optional register argument to
"				store the deleted lines in; defaults to black
"				hole register.
"   1.00.005	20-Jul-2012	FIX: Implement clipping for ]D.
"   1.00.004	19-Jul-2012	FIX: Clipping for ]E must consider the amount of
"				lines of the source fold and subtract them from
"				the last available line number. Add optional
"				lastLineDefault argument to
"				LineJuggler#ClipAddress().
"				Use visible, not physical target lines when
"				swapping with [E / ]E (also in visual mode) and
"				the target starts on a non-folded line.
"				Change {Visual}[f / ]f to use visible, not
"				physical target lines, too.
"				FIX: Handle "E134: Move lines into themselves"
"				:move error.
"   1.00.003	18-Jul-2012	Factor out LineJuggler#ClipAddress().
"				Make [<Space> / ]<Space> keep the current line
"				also when inside a fold.
"   			    	Consolidate the separate LineJuggler#BlankUp() /
"				LineJuggler#BlankDown() functions.
"				Keep current line for {Visual}[<Space>.
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

function! s:VisualReselect()
    " With :<C-u>, we're always in the first line of the selection. To get the
    " actual line of the cursor, we need to leave the visual selection. We
    " cannot do that initially before invoking this function, since then the
    " [count] would be lost. So do this now to get the current line.
    execute "normal! gv\<C-\>\<C-n>"
endfunction

function! LineJuggler#FoldClosed( ... )
    let l:lnum = (a:0 ? a:1 : line('.'))
    return foldclosed(l:lnum) == -1 ? l:lnum : foldclosed(l:lnum)
endfunction
function! LineJuggler#FoldClosedEnd( ... )
    let l:lnum = (a:0 ? a:1 : line('.'))
    return foldclosedend(l:lnum) == -1 ? l:lnum : foldclosedend(l:lnum)
endfunction

function! LineJuggler#ClipAddress( address, direction, firstLineDefault, ... )
    " Beep when already on the first / last line, but allow an arbitrary large
    " count to move to the first / last line.
    if a:address < 0
	if a:direction == -1
	    if LineJuggler#FoldClosed() == 1
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return -1
	    else
		return a:firstLineDefault
	    endif
	else
	    if LineJuggler#FoldClosedEnd() == line('$')
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return -1
	    else
		return a:0 ? a:1 : line('$')
	    endif
	endif
    endif
    return a:address
endfunction



function! LineJuggler#Blank( address, count, direction, mapSuffix )
    let l:original_lnum = line('.')
	call ingolines#PutWrapper(a:address, 'put' . (a:direction == -1 ? '!' : ''), repeat(nr2char(10), a:count))
    execute (l:original_lnum + (a:direction == -1 ? a:count : 0))

    silent! call       repeat#set("\<Plug>(LineJugglerBlank" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerBlank" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#VisualBlank( address, direction, mapSuffix )
    let l:count = v:count1
    call s:VisualReselect()

    call LineJuggler#Blank(a:address, l:count, a:direction, a:mapSuffix)
endfunction

function! LineJuggler#Move( range, address, count, direction, mapSuffix )
    let l:address = LineJuggler#ClipAddress(a:address, a:direction, 0)
    if l:address == -1 | return | endif

    try
	let l:save_mark = getpos("''")
	    call setpos("''", getpos('.'))
		execute a:range . 'move' l:address
	    execute line("'`")
    catch /^Vim\%((\a\+)\)\=:E/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.

	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away.
	let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    finally
	call setpos("''", l:save_mark)

	silent! call       repeat#set("\<Plug>(LineJugglerMove" . a:mapSuffix . ')', a:count)
	silent! call visualrepeat#set("\<Plug>(LineJugglerMove" . a:mapSuffix . ')', a:count)
    endtry
endfunction
function! LineJuggler#VisualMove( direction, mapSuffix )
    let l:count = v:count1
    call s:VisualReselect()

    let l:targetLnum = ingowindow#RelativeWindowLine(line('.'), l:count, a:direction) - (a:direction == -1 ? 1 : 0)
    call LineJuggler#Move(
    \   "'<,'>",
    \   l:targetLnum,
    \   l:count,
    \   a:direction,
    \   a:mapSuffix
    \)
endfunction

function! s:DoSwap( sourceStartLnum, sourceEndLnum, targetStartLnum, targetEndLnum )
    if  a:sourceStartLnum <= a:targetStartLnum && a:sourceEndLnum >= a:targetStartLnum ||
    \   a:targetStartLnum <= a:sourceStartLnum && a:targetEndLnum >= a:sourceStartLnum
	throw 'LineJuggler: Overlap in the ranges to swap'
    endif

    let l:sourceLines = getline(a:sourceStartLnum, a:sourceEndLnum)
    let l:targetLines = getline(a:targetStartLnum, a:targetEndLnum)

    call ingolines#Replace(a:sourceStartLnum, a:sourceEndLnum, l:targetLines)

    let l:offset = (a:sourceEndLnum <= a:targetStartLnum ? len(l:targetLines) - len(l:sourceLines) : 0)
    call ingolines#Replace(a:targetStartLnum + l:offset, a:targetEndLnum + l:offset, l:sourceLines)
endfunction
function! LineJuggler#Swap( startLnum, endLnum, address, count, direction, mapSuffix, ... )
    let l:sourceLineCnt = (a:0 ? a:1 : a:endLnum - a:startLnum + 1)
    let l:address = LineJuggler#ClipAddress(a:address, a:direction,
    \   1, (a:direction == -1 ? line('$') : ingowindow#RelativeWindowLine(line('$'), (l:sourceLineCnt - 1), -1, -1))
    \)
    if l:address == -1 | return | endif

    " Always use the relative line addressing when swapping a visual selection;
    " the second conditional branch is just for the single-line normal mode
    " swap.
    " Note: Use a:address instead of l:address for the fold check here, so that
    " in the clipping case, the unfolded conditional is always used.
    let [l:targetStartLnum, l:targetEndLnum] = (
    \   a:0 || foldclosed(a:address) == -1 ?
    \       [l:address, ingowindow#RelativeWindowLine(l:address, (l:sourceLineCnt - 1), 1)] :
    \       [foldclosed(l:address), foldclosedend(l:address)]
    \   )

    try
	call s:DoSwap(a:startLnum, a:endLnum, l:targetStartLnum, l:targetEndLnum)
    catch /^LineJuggler:/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.

	let v:errmsg = substitute(v:exception, '^LineJuggler:\s*', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    endtry

    silent! call       repeat#set("\<Plug>(LineJugglerSwap" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerSwap" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#VisualSwap( direction, mapSuffix )
    let l:count = v:count1
    let l:visibleSelectedLineCnt = ingowindow#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    let l:targetLnum = ingowindow#RelativeWindowLine(line('.'), l:count, a:direction)
    call LineJuggler#Swap(
    \   line("'<"), line("'>"),
    \   l:targetLnum,
    \   l:count,
    \   a:direction,
    \   a:mapSuffix,
    \   l:visibleSelectedLineCnt
    \)
endfunction

function! LineJuggler#DupToOffset( insLnum, lines, isUp, offset, count, mapSuffix )
    if a:isUp
	let l:lnum = max([0, a:insLnum - a:offset + 1])
	call ingolines#PutWrapper(l:lnum, 'put!', a:lines)
    else
	let l:lnum = min([line('$'), a:insLnum + a:offset - 1])
	call ingolines#PutWrapper(l:lnum, 'put', a:lines)
    endif

    silent! call       repeat#set("\<Plug>(LineJugglerDup" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerDup" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#Dup( direction, count, mapSuffix )
    if a:count
	let l:insLnum = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, a:direction, -1), a:direction, 1)
	let l:lines = getline(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd())
    else
	let l:insLnum = (a:direction == -1 ? LineJuggler#FoldClosed() : LineJuggler#FoldClosedEnd())
	let l:lines = getline(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd())
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   l:lines,
    \   (a:direction == -1), 1,
    \   a:count,
    \   a:mapSuffix
    \)
endfunction
function! LineJuggler#VisualDup( direction, count, mapSuffix )
    let l:count = v:count1
    call s:VisualReselect()

    if l:count
	let l:insLnum = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine((a:direction == -1 ? line("'<") : line("'>")), a:count, a:direction, -1), a:direction, 1)
    else
	let l:insLnum = (a:direction == -1 ? line("'<") : line("'>"))
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   getline("'<", "'>"),
    \   (a:direction == -1), 1,
    \   l:count,
    \   a:mapSuffix
    \)

endfunction

function! LineJuggler#DupRange( count, direction, mapSuffix )
    let l:address = LineJuggler#FoldClosed()
    let l:endAddress = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count - 1, 1), a:direction, 1)
    if l:endAddress == -1 | return | endif

    if a:direction == -1
	let l:insLnum = l:address
	let l:isUp = 1
    else
	let l:insLnum = l:endAddress
	let l:isUp = 0
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   getline(l:address, l:endAddress),
    \   l:isUp, 1, a:count,
    \   a:mapSuffix
    \)
endfunction

function! LineJuggler#DupFetch( count, direction, mapSuffix )
    if a:direction == -1
	let l:address = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, -1, 1), a:direction, 1)
	let l:count = a:count
    else
	let l:address = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, 1, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, 1), a:direction, 1)
	" Note: To repeat with the following line, we need to increase v:count by one.
	let l:count = a:count + 1
    endif
    call LineJuggler#DupToOffset(
    \   LineJuggler#FoldClosedEnd(),
    \   getline(l:address, l:endAddress),
    \   0, 1, l:count,
    \   a:mapSuffix
    \)
endfunction
function! LineJuggler#VisualDupFetch( direction, mapSuffix )
    let l:count = v:count1
    let l:visibleSelectedLineCnt = ingowindow#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    let l:targetStartLnum = LineJuggler#ClipAddress(
    \   ingowindow#RelativeWindowLine(line('.'), l:count, a:direction, -1),
    \   a:direction,
    \   1, (a:direction == -1 ? line('$') : ingowindow#RelativeWindowLine(line('$'), (l:visibleSelectedLineCnt - 1), -1, -1))
    \)
    let l:targetEndLnum   = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(l:targetStartLnum, (l:visibleSelectedLineCnt - 1), 1), a:direction, 1)
    let l:lines = getline(l:targetStartLnum, l:targetEndLnum)

    if a:direction == -1
	let l:insLnum = line("'>")
	let l:isUp = 0
    else
	let l:insLnum = line("'<")
	let l:isUp = 1
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   l:lines,
    \   l:isUp, 1,
    \   l:count,
    \   a:mapSuffix
    \)
endfunction

function! s:RepFetch( startLnum, endLnum, lines, count, mapSuffix )
    call ingolines#Replace(a:startLnum, a:endLnum, a:lines, v:register)

    silent! call       repeat#set("\<Plug>(LineJugglerRepFetch" . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJugglerRepFetch" . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#RepFetch( count, direction, mapSuffix )
    if a:direction == -1
	let l:address = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, -1, 1), a:direction, 1)
    else
	let l:address = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, 1, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(line('.'), a:count, 1), a:direction, 1)
    endif
    let l:sourceLines = getline(l:address, l:endAddress)

    call s:RepFetch(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd(), l:sourceLines, a:count, a:mapSuffix)
endfunction
function! LineJuggler#VisualRepFetch( direction, mapSuffix )
    let l:count = v:count1
    let l:visibleSelectedLineCnt = ingowindow#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    let l:targetStartLnum = LineJuggler#ClipAddress(
    \   ingowindow#RelativeWindowLine(line('.'), l:count, a:direction, -1),
    \   a:direction,
    \   1, (a:direction == -1 ? line('$') : ingowindow#RelativeWindowLine(line('$'), (l:visibleSelectedLineCnt - 1), -1, -1))
    \)
    let l:targetEndLnum   = LineJuggler#ClipAddress(ingowindow#RelativeWindowLine(l:targetStartLnum, (l:visibleSelectedLineCnt - 1), 1), a:direction, 1)
    let l:lines = getline(l:targetStartLnum, l:targetEndLnum)

    call s:RepFetch(line("'<"), line("'>"), l:lines, l:count, a:mapSuffix)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
