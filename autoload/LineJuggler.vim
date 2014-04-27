" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - LineJuggler/IntraLine.vim autoload script
"   - ingo/folds.vim autoload script
"   - ingo/lines.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/window/dimensions.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.020	12-Nov-2013	Implement characterwise selection blank with
"				[<Space>, ]<Space>.
"				FIX: Don't use the (potentially adapted) fetch
"				count for a visual mode repeat.
"   2.00.019	11-Nov-2013	Implement characterwise selection swap with [E,
"				]E.
"				Implement characterwise selection fetch and
"				replace with [r, ]r.
"   2.00.018	29-Oct-2013	Add dedicated LineJuggler#VisualDupRange() for
"				the special visual intra-line handling for
"				[D / ]D.
"				Factor out s:RepeatSet() to avoid repetition.
"   2.00.017	27-Oct-2013	Explicitly pass v:count1 everywhere, it saves a
"				variable assignment inside the functions.
"				ENH: Implement special DWIM behavior for
"				duplication of characterwise single-line
"				selection: Duplicate before / after the
"				selection in the same line.
"   1.23.016	26-Oct-2013	Add message "N lines swapped with M lines" on [E
"				/ ]E.
"				Add message "Replaced N lines" for [r / ]r.
"   1.23.015	12-Jul-2013	Precaution: Use :keepjumps when setting mark '.
"   1.23.014	14-Jun-2013	Use ingo/msg.vim.
"   1.23.013	08-Apr-2013	Move ingowindow.vim functions into ingo-library.
"   1.23.012	04-Apr-2013	Move ingolines.vim into ingo-library.
"   1.22.011	08-Mar-2013	Expose s:DoSwap() as LineJuggler#SwapRanges()
"				for use with the companion
"				LineJugglerCommands.vim plugin.
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

function! s:IsSingleLineCharacterwiseSelection()
    return (visualmode() ==# 'v' && line("'<") == line("'>"))
endfunction
function! s:VisualReselect()
    " With :<C-u>, we're always in the first line of the selection. To get the
    " actual line of the cursor, we need to leave the visual selection. We
    " cannot do that initially before invoking this function, since then the
    " [count] would be lost. So do this now to get the current line.
    execute "normal! gv\<C-\>\<C-n>"
endfunction
function! s:RepeatSet( what, count, mapSuffix )
    silent! call       repeat#set("\<Plug>(LineJuggler" . a:what . a:mapSuffix . ')', a:count)
    silent! call visualrepeat#set("\<Plug>(LineJuggler" . a:what . a:mapSuffix . ')', a:count)
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
	call ingo#lines#PutWrapper(a:address, 'put' . (a:direction == -1 ? '!' : ''), repeat(nr2char(10), a:count))
    execute (l:original_lnum + (a:direction == -1 ? a:count : 0))

    call s:RepeatSet('Blank', a:count, a:mapSuffix)
endfunction
function! LineJuggler#VisualBlank( address, direction, count, mapSuffix )
    call s:VisualReselect()

    if s:IsSingleLineCharacterwiseSelection()
	return LineJuggler#IntraLine#Blank(a:direction, a:count, a:mapSuffix)
    endif

    call LineJuggler#Blank(a:address, a:count, a:direction, a:mapSuffix)
endfunction

function! LineJuggler#Move( range, address, count, direction, mapSuffix )
    let l:address = LineJuggler#ClipAddress(a:address, a:direction, 0)
    if l:address == -1 | return | endif

    try
	let l:save_mark = getpos("''")
	    keepjumps call setpos("''", getpos('.'))
		execute a:range . 'move' l:address
	    execute line("'`")
    catch /^Vim\%((\a\+)\)\=:E/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	call ingo#msg#VimExceptionMsg()
    finally
	keepjumps call setpos("''", l:save_mark)

	call s:RepeatSet('Move', a:count, a:mapSuffix)
    endtry
endfunction
function! LineJuggler#VisualMove( direction, count, mapSuffix )
    call s:VisualReselect()

    if s:IsSingleLineCharacterwiseSelection()
	let l:targetLnum = ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1 * a:direction)
	return LineJuggler#IntraLine#Move(a:direction, l:targetLnum, a:count, a:mapSuffix)
    endif

    let l:targetLnum = ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction) - (a:direction == -1 ? 1 : 0)
    call LineJuggler#Move(
    \   "'<,'>",
    \   l:targetLnum,
    \   a:count,
    \   a:direction,
    \   a:mapSuffix
    \)
endfunction

function! LineJuggler#SwapRanges( sourceStartLnum, sourceEndLnum, targetStartLnum, targetEndLnum )
    if  a:sourceStartLnum <= a:targetStartLnum && a:sourceEndLnum >= a:targetStartLnum ||
    \   a:targetStartLnum <= a:sourceStartLnum && a:targetEndLnum >= a:sourceStartLnum
	throw 'LineJuggler: Overlap in the ranges to swap'
    endif

    let l:sourceLines = getline(a:sourceStartLnum, a:sourceEndLnum)
    let l:targetLines = getline(a:targetStartLnum, a:targetEndLnum)

    call ingo#lines#Replace(a:sourceStartLnum, a:sourceEndLnum, l:targetLines)

    let l:offset = (a:sourceEndLnum <= a:targetStartLnum ? len(l:targetLines) - len(l:sourceLines) : 0)
    call ingo#lines#Replace(a:targetStartLnum + l:offset, a:targetEndLnum + l:offset, l:sourceLines)

    let l:sourceLineNum = a:sourceEndLnum - a:sourceStartLnum + 1
    let l:targetLineNum = a:targetEndLnum - a:targetStartLnum + 1
    if l:sourceLineNum > &report || l:targetLineNum > &report
	echomsg printf('%d line%s swapped with %d line%s',
	\   l:sourceLineNum, (l:sourceLineNum == 1 ? '' : 's'), l:targetLineNum, (l:targetLineNum == 1 ? '' : 's')
	\)
    endif
endfunction
function! LineJuggler#Swap( startLnum, endLnum, address, count, direction, mapSuffix, ... )
    let l:sourceLineCnt = (a:0 ? a:1 : a:endLnum - a:startLnum + 1)
    let l:address = LineJuggler#ClipAddress(a:address, a:direction,
    \   1, (a:direction == -1 ? line('$') : ingo#folds#RelativeWindowLine(line('$'), (l:sourceLineCnt - 1), -1, -1))
    \)
    if l:address == -1 | return | endif

    " Always use the relative line addressing when swapping a visual selection;
    " the second conditional branch is just for the single-line normal mode
    " swap.
    " Note: Use a:address instead of l:address for the fold check here, so that
    " in the clipping case, the unfolded conditional is always used.
    let [l:targetStartLnum, l:targetEndLnum] = (
    \   a:0 || foldclosed(a:address) == -1 ?
    \       [l:address, ingo#folds#RelativeWindowLine(l:address, (l:sourceLineCnt - 1), 1)] :
    \       [foldclosed(l:address), foldclosedend(l:address)]
    \   )

    try
	call LineJuggler#SwapRanges(a:startLnum, a:endLnum, l:targetStartLnum, l:targetEndLnum)
    catch /^LineJuggler:/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	call ingo#msg#CustomExceptionMsg('LineJuggler')
    endtry

    call s:RepeatSet('Swap', a:count, a:mapSuffix)
endfunction
function! LineJuggler#VisualSwap( direction, count, mapSuffix )
    let l:visibleSelectedLineCnt = ingo#window#dimensions#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    if s:IsSingleLineCharacterwiseSelection()
	let l:targetLnum = ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1 * a:direction)
	return LineJuggler#IntraLine#Swap(a:direction, l:targetLnum, a:count, a:mapSuffix)
    endif

    let l:targetLnum = ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction)
    call LineJuggler#Swap(
    \   line("'<"), line("'>"),
    \   l:targetLnum,
    \   a:count,
    \   a:direction,
    \   a:mapSuffix,
    \   l:visibleSelectedLineCnt
    \)
endfunction

function! LineJuggler#DupToOffset( insLnum, lines, isUp, offset, count, mapSuffix )
    if a:isUp
	let l:lnum = max([0, a:insLnum - a:offset + 1])
	call ingo#lines#PutWrapper(l:lnum, 'put!', a:lines)
    else
	let l:lnum = min([line('$'), a:insLnum + a:offset - 1])
	call ingo#lines#PutWrapper(l:lnum, 'put', a:lines)
    endif

    call s:RepeatSet('Dup', a:count, a:mapSuffix)
endfunction
function! LineJuggler#Dup( direction, count, mapSuffix )
    if a:count
	let l:insLnum = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1), a:direction, 1)
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
    if s:IsSingleLineCharacterwiseSelection()
	return LineJuggler#IntraLine#Dup(a:direction, a:count, a:mapSuffix)
    endif

    call s:VisualReselect()

    if a:count
	let l:insLnum = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine((a:direction == -1 ? line("'<") : line("'>")), a:count, a:direction, -1), a:direction, 1)
    else
	let l:insLnum = (a:direction == -1 ? line("'<") : line("'>"))
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   getline("'<", "'>"),
    \   (a:direction == -1), 1,
    \   a:count,
    \   a:mapSuffix
    \)
endfunction

function! LineJuggler#DupRange( count, direction, mapSuffix )
    let l:address = LineJuggler#FoldClosed()
    let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count - 1, 1), a:direction, 1)
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
function! LineJuggler#VisualDupRange( insLnum, isUp, offset, count, mapSuffix )
    if s:IsSingleLineCharacterwiseSelection()
	return LineJuggler#IntraLine#DupRange((a:isUp ? -1 : 1), a:count, a:mapSuffix)
    endif

    call LineJuggler#DupToOffset(
    \   a:insLnum,
    \   repeat(getline("'<", "'>"), a:count),
    \   a:isUp,
    \   a:offset,
    \   a:count,
    \   a:mapSuffix
    \)
endfunction

function! LineJuggler#DupFetch( count, direction, mapSuffix )
    if a:direction == -1
	let l:address = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, -1, 1), a:direction, 1)
	" Note: To repeat with the following line, we need to increase the count by one less than the number of fetched lines, so usually nothing.
	let l:count = a:count + (l:endAddress - l:address)
    else
	let l:address = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, 1, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, 1), a:direction, 1)
	" Note: To repeat with the following line, we need to increase the count by one.
	let l:count = a:count + 1
    endif
    call LineJuggler#DupToOffset(
    \   LineJuggler#FoldClosedEnd(),
    \   getline(l:address, l:endAddress),
    \   0, 1, l:count,
    \   a:mapSuffix
    \)

    " Don't use the (potentially adapted) l:count for a visual mode repeat; the
    " increase is meant for normal mode repeat only!
    silent! call visualrepeat#set("\<Plug>(LineJuggler" . 'Dup' . a:mapSuffix . ')', a:count)
endfunction
function! LineJuggler#VisualDupFetch( direction, count, mapSuffix )
    let l:visibleSelectedLineCnt = ingo#window#dimensions#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    let l:targetStartLnum = LineJuggler#ClipAddress(
    \   ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1),
    \   a:direction,
    \   1, (a:direction == -1 ? line('$') : ingo#folds#RelativeWindowLine(line('$'), (l:visibleSelectedLineCnt - 1), -1, -1))
    \)
    let l:targetEndLnum   = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(l:targetStartLnum, (l:visibleSelectedLineCnt - 1), 1), a:direction, 1)
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
    \   a:count,
    \   a:mapSuffix
    \)
endfunction

function! s:RepFetch( startLnum, endLnum, lines, count, mapSuffix )
    call ingo#lines#Replace(a:startLnum, a:endLnum, a:lines, v:register)
    let l:lineNum = a:endLnum - a:startLnum + 1
    if l:lineNum > &report
	echomsg printf('Replaced %d line%s', l:lineNum, (l:lineNum == 1 ? '' : 's')) .
	\   (len(a:lines) != l:lineNum ?
	\       printf(' with %s line%s', len(a:lines), (len(a:lines) == 1 ? '' : 's')) :
	\       ''
	\   )
    endif

    call s:RepeatSet('RepFetch', a:count, a:mapSuffix)
endfunction
function! LineJuggler#RepFetch( count, direction, mapSuffix )
    if a:direction == -1
	let l:address = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, -1, 1), a:direction, 1)
    else
	let l:address = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, 1, -1), a:direction, 1)
	if l:address == -1 | return | endif
	let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:count, 1), a:direction, 1)
    endif
    let l:sourceLines = getline(l:address, l:endAddress)

    call s:RepFetch(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd(), l:sourceLines, a:count, a:mapSuffix)
endfunction
function! LineJuggler#VisualRepFetch( direction, count, mapSuffix )
    let l:visibleSelectedLineCnt = ingo#window#dimensions#NetVisibleLines(line("'<"), line("'>"))
    call s:VisualReselect()

    if s:IsSingleLineCharacterwiseSelection()
	let l:targetLnum = ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1 * a:direction)
	return LineJuggler#IntraLine#RepFetch(a:direction, l:targetLnum, a:count, a:mapSuffix)
    endif

    let l:targetStartLnum = LineJuggler#ClipAddress(
    \   ingo#folds#RelativeWindowLine(line('.'), a:count, a:direction, -1),
    \   a:direction,
    \   1, (a:direction == -1 ? line('$') : ingo#folds#RelativeWindowLine(line('$'), (l:visibleSelectedLineCnt - 1), -1, -1))
    \)
    let l:targetEndLnum   = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(l:targetStartLnum, (l:visibleSelectedLineCnt - 1), 1), a:direction, 1)
    let l:lines = getline(l:targetStartLnum, l:targetEndLnum)

    call s:RepFetch(line("'<"), line("'>"), l:lines, a:count, a:mapSuffix)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
