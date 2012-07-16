" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - LineJuggler.vim autoload script
"   - ingowindow.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.005	12-Jul-2012	ENH: Add visual [f / ]f mappings.
"				ENH: Add visual [<Space> / ]<Space> mappings.
"				Moved functions to separate autoload script.
"	004	11-Jul-2012	FIX: Handle readonly / nomodifiable buffer
"				warning / error.
"				ENH: In all mappings, include all lines of
"				closed folds and interpret [count] as the number
"				of visible lines, i.e. count closed folds as one
"				count. With this, moves and duplications are
"				always done "over", never "into" closed folds,
"				and the 'relativenumber' column can be used to
"				determine the [count] to reach a target.
"				ENH: Add [f / ]f mappings to fetch adjacent line
"				and duplicate it below the current one.
"	003	10-Jul-2012	BUG: Move up and down cause "E134: Move lines
"				into themselves" when using inside a closed
"				fold. Calculate the target address from the
"				fold's border instead of simple relative line
"				addressing.
"				FIX: Beep / truncate instead of causing error
"				when moving up / down at the first / last line.
"				FIX: Correct use of repeat mapping in move up
"				and down mappings.
"	002	21-Jun-2012	Rename all mappings to include the mapping name
"				in (...), as recommended by my style guide.
"				Add LineJugglerDupRangeDown / ]D alternative
"				mappings that interpret [count] as the range /
"				multiplier of the visual selection rather than
"				the number of lines to skip.
"				FIX: Work around Vim :put behavior to duplicate
"				line ranges ending with an empty line correctly.
"	001	12-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_LineJuggler') || (v:version < 700)
    finish
endif
let g:loaded_LineJuggler = 1
let s:save_cpo = &cpo
set cpo&vim

"- mappings --------------------------------------------------------------------

nnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-U>call setline(1, getline(1))<Bar>call LineJuggler#BlankUp('', v:count1)<CR>
nnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-U>call setline(1, getline(1))<Bar>call LineJuggler#BlankDown('', v:count1)<CR>
xnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-U>call setline(1, getline(1))<Bar>call LineJuggler#BlankUp("'<", v:count1)<CR>
xnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-U>call setline(1, getline(1))<Bar>call LineJuggler#BlankDown("'>", v:count1)<CR>
if ! hasmapto('<Plug>(LineJugglerBlankUp)', 'n')
    nmap [<Space> <Plug>(LineJugglerBlankUp)
endif
if ! hasmapto('<Plug>(LineJugglerBlankDown)', 'n')
    nmap ]<Space> <Plug>(LineJugglerBlankDown)
endif
if ! hasmapto('<Plug>(LineJugglerBlankUp)', 'x')
    xmap [<Space> <Plug>(LineJugglerBlankUp)
endif
if ! hasmapto('<Plug>(LineJugglerBlankDown)', 'x')
    xmap ]<Space> <Plug>(LineJugglerBlankDown)
endif



nnoremap <silent> <Plug>(LineJugglerMoveUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Move(
\   LineJuggler#FoldClosed(),
\   ingowindow#RelativeWindowLine(line('.'), v:count1, -1) - 1,
\   v:count1,
\   'Up'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerMoveDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Move(
\   LineJuggler#FoldClosedEnd(),
\   ingowindow#RelativeWindowLine(line('.'), v:count1,  1),
\   v:count1,
\   'Down'
\)<CR>
xnoremap <silent> <Plug>(LineJugglerMoveUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Move(
\   "'<,'>",
\   ingowindow#RelativeWindowLine(line("'<"), v:count1, -1) - 1,
\   v:count1,
\   'Up'
\)<CR>
xnoremap <silent> <Plug>(LineJugglerMoveDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Move(
\   "'<,'>",
\   ingowindow#RelativeWindowLine(line("'>"), v:count1,  1),
\   v:count1,
\   'Down'
\)<CR>
if ! hasmapto('<Plug>(LineJugglerMoveUp)', 'n')
    nmap [e <Plug>(LineJugglerMoveUp)
endif
if ! hasmapto('<Plug>(LineJugglerMoveDown)', 'n')
    nmap ]e <Plug>(LineJugglerMoveDown)
endif
if ! hasmapto('<Plug>(LineJugglerMoveUp)', 'x')
    xmap [e <Plug>(LineJugglerMoveUp)
endif
if ! hasmapto('<Plug>(LineJugglerMoveDown)', 'x')
    xmap ]e <Plug>(LineJugglerMoveDown)
endif



nnoremap <silent> <Plug>(LineJugglerDupOverUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   LineJuggler#FoldClosed(),
\   getline(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd()),
\   1,
\   v:count1,
\   v:count1,
\   'OverUp'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupOverDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   LineJuggler#FoldClosedEnd(),
\   getline(LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd()),
\   0,
\   v:count1,
\   v:count1,
\   'OverDown'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupOverUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   line("'<"),
\   getline("'<", "'>"),
\   1,
\   v:count1,
\   v:count1,
\   'OverUp'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupOverDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   line("'>"),
\   getline("'<", "'>"),
\   0,
\   v:count1,
\   v:count1,
\   'OverDown'
\)<CR>
if ! hasmapto('<Plug>(LineJugglerDupOverUp)', 'n')
    nmap [d <Plug>(LineJugglerDupOverUp)
endif
if ! hasmapto('<Plug>(LineJugglerDupOverDown)', 'n')
    nmap ]d <Plug>(LineJugglerDupOverDown)
endif
if ! hasmapto('<Plug>(LineJugglerDupOverUp)', 'x')
    xmap [d <Plug>(LineJugglerDupOverUp)
endif
if ! hasmapto('<Plug>(LineJugglerDupOverDown)', 'x')
    xmap ]d <Plug>(LineJugglerDupOverDown)
endif



nnoremap <silent> <Plug>(LineJugglerDupRangeUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   LineJuggler#FoldClosed(),
\   getline(LineJuggler#FoldClosed(), ingowindow#RelativeWindowLine(line('.'), v:count1 - 1, 1)),
\   1, 1, v:count1,
\   'RangeUp'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupRangeDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   ingowindow#RelativeWindowLine(line('.'), v:count1 - 1, 1),
\   getline(LineJuggler#FoldClosed(), ingowindow#RelativeWindowLine(line('.'), v:count1 - 1, 1)),
\   0, 1, v:count1,
\   'RangeDown'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupRangeUp)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   line("'<"),
\   repeat(getline("'<", "'>"), v:count1),
\   1, 1, v:count1,
\   'RangeUp'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupRangeDown) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   line("'>"),
\   repeat(getline("'<", "'>"), v:count1),
\   0, 1, v:count1,
\   'RangeDown'
\)<CR>
if ! hasmapto('<Plug>(LineJugglerDupRangeUp)', 'n')
    nmap [D <Plug>(LineJugglerDupRangeUp)
endif
if ! hasmapto('<Plug>(LineJugglerDupRangeDown)', 'n')
    nmap ]D <Plug>(LineJugglerDupRangeDown)
endif
if ! hasmapto('<Plug>(LineJugglerDupRangeUp)', 'x')
    xmap [D <Plug>(LineJugglerDupRangeUp)
endif
if ! hasmapto('<Plug>(LineJugglerDupRangeDown)', 'x')
    xmap ]D <Plug>(LineJugglerDupRangeDown)
endif



nnoremap <silent> <Plug>(LineJugglerDupFetchAbove)   :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   LineJuggler#FoldClosedEnd(),
\   getline(ingowindow#RelativeWindowLine(line('.'), v:count1, -1), ingowindow#RelativeWindowLine(line('.'), v:count1, -1, 1)),
\   0, 1, v:count1,
\   'FetchAbove'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupFetchBelow) :<C-U>call setline(1, getline(1))<Bar>
\call LineJuggler#Dup(
\   LineJuggler#FoldClosedEnd(),
\   getline(ingowindow#RelativeWindowLine(line('.'), v:count1, 1, -1), ingowindow#RelativeWindowLine(line('.'), v:count1, 1)),
\   0, 1, v:count1 + 1,
\   'FetchBelow'
\)<CR>
" Note: To repeat with the following line, we need to increase v:count by one.
if ! hasmapto('<Plug>(LineJugglerDupFetchAbove)', 'n')
    nmap ]f <Plug>(LineJugglerDupFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerDupFetchBelow)', 'n')
    nmap [f <Plug>(LineJugglerDupFetchBelow)
endif



xnoremap <silent> <Plug>(LineJugglerDupFetchAbove)   :<C-u>call LineJuggler#VisualDupFetch(-1, 'FetchAbove')<CR>
xnoremap <silent> <Plug>(LineJugglerDupFetchBelow)   :<C-u>call LineJuggler#VisualDupFetch( 1, 'FetchBelow')<CR>
if ! hasmapto('<Plug>(LineJugglerDupFetchAbove)', 'x')
    xmap ]f <Plug>(LineJugglerDupFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerDupFetchBelow)', 'x')
    xmap [f <Plug>(LineJugglerDupFetchBelow)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
