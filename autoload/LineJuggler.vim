" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - LineJuggler/IntraLine.vim autoload script
"   - ingo/folds.vim autoload script
"   - ingo/lines.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/range.vim autoload script
"   - ingo/window/dimensions.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
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

function! LineJuggler#ClipAddress( address, direction, firstLineDefault, ... )
    " Beep when already on the first / last line, but allow an arbitrary large
    " count to move to the first / last line.
    if a:address < 0
	if a:direction == -1
	    if ingo#range#NetStart() == 1
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return -1
	    else
		return a:firstLineDefault
	    endif
	else
	    if ingo#range#NetEnd() == line('$')
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return -1
	    else
		return a:0 ? a:1 : line('$')
	    endif
	endif
    endif
    return a:address
endfunction


function! LineJuggler#InsertBlankLine( address, count, direction )
    call ingo#lines#PutWrapper(a:address, 'put' . (a:direction == -1 ? '!' : ''), repeat(nr2char(10), a:count))
endfunction
function! LineJuggler#Blank( address, count, direction, mapSuffix )
    let l:original_lnum = line('.')
	call LineJuggler#InsertBlankLine(a:address, a:count, a:direction)
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

    let l:save_foldenable = &l:foldenable
    setlocal nofoldenable
    try
	let l:save_mark = getpos("''")
	    keepjumps call setpos("''", getpos('.'))
		execute a:range . 'move' l:address
	    execute line("'`")
    catch /^Vim\%((\a\+)\)\=:/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	call ingo#msg#VimExceptionMsg()
    finally
	keepjumps call setpos("''", l:save_mark)
	let &l:foldenable = l:save_foldenable

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
	let l:lines = getline(ingo#range#NetStart(), ingo#range#NetEnd())
    else
	let l:insLnum = (a:direction == -1 ? ingo#range#NetStart() : ingo#range#NetEnd())
	let l:lines = getline(ingo#range#NetStart(), ingo#range#NetEnd())
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
    let l:address = ingo#range#NetStart()
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

function! LineJuggler#DupRangeOver( lineCount, skipCount, direction, mapSuffix, repeatCount )
    let l:address = ingo#range#NetStart()
    let l:endAddress = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(line('.'), a:lineCount - 1, 1), a:direction, 1)
    if l:endAddress == -1 | return | endif

    if a:direction == -1
	let l:insLnum = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(l:address, a:skipCount, a:direction, -1), a:direction, 1)
	let l:isUp = 1
    else
	let l:insLnum = LineJuggler#ClipAddress(ingo#folds#RelativeWindowLine(l:endAddress, a:skipCount, a:direction, -1), a:direction, 1)
	let l:isUp = 0
    endif

    call LineJuggler#DupToOffset(
    \   l:insLnum,
    \   getline(l:address, l:endAddress),
    \   l:isUp, 1, a:repeatCount,
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
    \   ingo#range#NetEnd(),
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

function! LineJuggler#ReplaceRanges( sourceStartLnum, sourceEndLnum, targetStartLnum, targetEndLnum, register )
    let l:lines = getline(a:sourceStartLnum, a:sourceEndLnum)
    call ingo#lines#Replace(a:targetStartLnum, a:targetEndLnum, l:lines, a:register)

    let l:sourceLineNum = a:sourceEndLnum - a:sourceStartLnum + 1
    let l:targetLineNum = a:targetEndLnum - a:targetStartLnum + 1
    if l:sourceLineNum > &report || l:targetLineNum > &report
	echomsg printf('Replaced %d line%s', l:targetLineNum, (l:targetLineNum == 1 ? '' : 's')) .
	\   (l:sourceLineNum != l:targetLineNum ?
	\       printf(' with %s line%s', l:sourceLineNum, (l:sourceLineNum == 1 ? '' : 's')) :
	\       ''
	\   )
    endif
endfunction
function! s:RepFetch( sourceStartLnum, sourceEndLnum, targetStartLnum, targetEndLnum, count, mapSuffix )
    call LineJuggler#ReplaceRanges(a:sourceStartLnum, a:sourceEndLnum, a:targetStartLnum, a:targetEndLnum, v:register)
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

    call s:RepFetch(l:address, l:endAddress, ingo#range#NetStart(), ingo#range#NetEnd(), a:count, a:mapSuffix)
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

    call s:RepFetch(l:targetStartLnum, l:targetEndLnum, line("'<"), line("'>"), a:count, a:mapSuffix)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
