" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - LineJuggler.vim autoload script
"   - ingo/folds.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.016	12-Nov-2013	Implement characterwise selection blank with
"				[<Space>, ]<Space>.
"   2.00.015	11-Nov-2013	Implement characterwise selection swap with [E,
"				]E.
"				Implement characterwise selection fetch and
"				replace with [r, ]r.
"   2.00.014	30-Oct-2013	Implement normal-mode repeat behavior for
"				intra-line dups at another line.
"   			    	Move the repeated normal mode repeat logic to
"   			    	the autoload script.
"   2.00.013	29-Oct-2013	Add dedicated LineJuggler#VisualDupRange() for
"				the special visual intra-line handling for
"				[D / ]D.
"				Add special <Plug>(LineJugglerDupIntra...)
"				mappings for the normal mode repeat of
"				intra-line duplications.
"				Add special <Plug>(LineJugglerMoveIntra...)
"				mappings for the normal mode repeat of
"				intra-line moves.
"   1.30.012	27-Oct-2013	Explicitly pass v:count1 everywhere, it saves a
"				variable assignment inside the functions.
"   1.23.011	08-Apr-2013	Move ingowindow.vim functions into ingo-library.
"   1.20.010	27-Jul-2012	Adapt [d and [D mappings to restructured and
"				changed implementation with
"				LineJuggler#DupToOffset().
"				FIX: Correct repeat of ]E.
"   1.10.009    23-Jul-2012	CHG: Split [f and {Visual}[f behaviors into two
"				families of mappings:
"				a) [f to fetch below current line and {Visual}[f
"				to fetch selected number of lines above/below
"				selection
"				b) [r to fetch and replace current line /
"				selection.
"   1.00.008	20-Jul-2012	FIX: Implement clipping for ]D.
"   1.00.007	18-Jul-2012	Consolidate the separate LineJuggler#BlankUp() /
"				LineJuggler#BlankDown() functions.
"				Keep current line for {Visual}[<Space>.
"   1.00.006	17-Jul-2012	ENH: Add [E / ]E mappings to swap lines.
"				CHG: Move distance in {Visual}[e / ]e is now
"				based on the current line, not the border of the
"				visual selection. This is more consistent and
"				allows the use of 'relativenumber'.
"				ENH: Add [E / ]E mappings to exchange lines.
"				FIX: Use current line for the setline()
"				unmodifiable / readonly check to avoid that undo
"				of the mapping jumps to line 1.
"				Avoid reporting "2 changes" when undoing [e,
"				{Visual}[f by making the line modification only
"				when necessary to force the warning / error.
"				Because of the use of :move / :put, there's no
"				way to make a modification while having Vim not
"				count the line as changed.
"   	005	12-Jul-2012	ENH: Add visual [f / ]f mappings.
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

nnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#Blank('', v:count1, -1, 'Up')<CR>
nnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#Blank('', v:count1,  1, 'Down')<CR>
vnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#VisualBlank("'<", -1, v:count1, 'Up')<CR>
vnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#VisualBlank("'>",  1, v:count1, 'Down')<CR>
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
" When repeating, add the same-sized blank area from the current position.
" Don't repeat on a closed fold.
nnoremap <silent> <Plug>(LineJugglerBlankIntraUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#BlankRepeat(-1, v:count1, 'Up')<CR>
nnoremap <silent> <Plug>(LineJugglerBlankIntraDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#BlankRepeat( 1, v:count1, 'Down')<CR>



nnoremap <silent> <Plug>(LineJugglerMoveUp)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#Move(
\   LineJuggler#FoldClosed(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1, -1) - 1,
\   v:count1,
\   -1,
\   'Up'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerMoveDown) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#Move(
\   LineJuggler#FoldClosedEnd(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1,  1),
\   v:count1,
\   1,
\   'Down'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerMoveUp)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualMove(-1, v:count1, 'Up')<CR>
vnoremap <silent> <Plug>(LineJugglerMoveDown) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualMove( 1, v:count1, 'Down')<CR>
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
" When repeating from the same position as left by a previous mapping
" invocation, re-use the same selection again, i.e. move the same text further.
" Elsewhere, move a same-sized selection starting from the current position.
" Don't repeat on a closed fold; just grabbing any invisible part from it is as
" bad as suddenly turning this into a regular, full-line move.
nnoremap <silent> <Plug>(LineJugglerMoveIntraUp)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#MoveRepeat(-1, v:count1, 'Up')<CR>
nnoremap <silent> <Plug>(LineJugglerMoveIntraDown) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#MoveRepeat( 1, v:count1, 'Down')<CR>



nnoremap <silent> <Plug>(LineJugglerSwapUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#Swap(
\   LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1, -1),
\   v:count1,
\   -1,
\   'Up'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerSwapDown)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#Swap(
\   LineJuggler#FoldClosed(), LineJuggler#FoldClosedEnd(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1,  1),
\   v:count1,
\   1,
\   'Down'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerSwapUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualSwap(-1, v:count1, 'Up')<CR>
vnoremap <silent> <Plug>(LineJugglerSwapDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualSwap( 1, v:count1, 'Down')<CR>
if ! hasmapto('<Plug>(LineJugglerSwapUp)', 'n')
    nmap [E <Plug>(LineJugglerSwapUp)
endif
if ! hasmapto('<Plug>(LineJugglerSwapDown)', 'n')
    nmap ]E <Plug>(LineJugglerSwapDown)
endif
if ! hasmapto('<Plug>(LineJugglerSwapUp)', 'x')
    xmap [E <Plug>(LineJugglerSwapUp)
endif
if ! hasmapto('<Plug>(LineJugglerSwapDown)', 'x')
    xmap ]E <Plug>(LineJugglerSwapDown)
endif
" When repeating from the same position as left by a previous mapping
" invocation, re-use the same selection again, i.e. swap the same text further.
" Elsewhere, swap a same-sized selection starting from the current position.
" Don't repeat on a closed fold; just grabbing any invisible part from it is as
" bad as suddenly turning this into a regular, full-line move.
nnoremap <silent> <Plug>(LineJugglerSwapIntraUp)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#SwapRepeat(-1, v:count1, 'Up')<CR>
nnoremap <silent> <Plug>(LineJugglerSwapIntraDown) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#SwapRepeat( 1, v:count1, 'Down')<CR>



nnoremap <silent> <Plug>(LineJugglerDupOverUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#Dup(
\   -1,
\   v:count,
\   'OverUp'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupOverDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#Dup(
\   1,
\   v:count,
\   'OverDown'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupOverUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualDup(
\   -1,
\   v:count,
\   'OverUp'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupOverDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualDup(
\   1,
\   v:count,
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
" When repeating from the same position as left by a previous mapping
" invocation, simply duplicate the same text again.
" Elsewhere, move a same-sized selection starting from the current position.
" Don't repeat on a closed fold; just grabbing any invisible part from it is as
" bad as suddenly turning this into a regular, full-line dup.
nnoremap <silent> <Plug>(LineJugglerDupIntraOverUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#DupRepeat('LineJuggler#VisualDup', -1, v:count, 'OverUp')<CR>
nnoremap <silent> <Plug>(LineJugglerDupIntraOverDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#DupRepeat('LineJuggler#VisualDup',  1, v:count, 'OverDown')<CR>



nnoremap <silent> <Plug>(LineJugglerDupRangeUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#DupRange(
\   v:count1,
\   -1,
\   'RangeUp'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupRangeDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#DupRange(
\   v:count1,
\   1,
\   'RangeDown'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupRangeUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualDupRange(
\   line("'<"),
\   1, 1, v:count1,
\   'RangeUp'
\)<CR>
vnoremap <silent> <Plug>(LineJugglerDupRangeDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#VisualDupRange(
\   line("'>"),
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
" When repeating from the same position as left by a previous mapping
" invocation, simply duplicate the same text again.
" Elsewhere, move a same-sized selection starting from the current position.
" Don't repeat on a closed fold; just grabbing any invisible part from it is as
" bad as suddenly turning this into a regular, full-line dup.
nnoremap <silent> <Plug>(LineJugglerDupIntraRangeUp)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#DupRepeat('LineJuggler#VisualDupRange', line("'<"), 1, 1, v:count1, 'RangeUp')<CR>
nnoremap <silent> <Plug>(LineJugglerDupIntraRangeDown) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#IntraLine#DupRepeat('LineJuggler#VisualDupRange', line("'<"), 0, 1, v:count1, 'RangeDown')<CR>



nnoremap <silent> <Plug>(LineJugglerDupFetchAbove)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#DupFetch(
\   v:count1,
\   -1,
\   'FetchAbove'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerDupFetchBelow) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#DupFetch(
\   v:count1,
\   1,
\   'FetchBelow'
\)<CR>
if ! hasmapto('<Plug>(LineJugglerDupFetchAbove)', 'n')
    nmap ]f <Plug>(LineJugglerDupFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerDupFetchBelow)', 'n')
    nmap [f <Plug>(LineJugglerDupFetchBelow)
endif

vnoremap <silent> <Plug>(LineJugglerDupFetchAbove)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualDupFetch(-1, v:count1, 'FetchAbove')<CR>
vnoremap <silent> <Plug>(LineJugglerDupFetchBelow)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualDupFetch( 1, v:count1, 'FetchBelow')<CR>
if ! hasmapto('<Plug>(LineJugglerDupFetchAbove)', 'x')
    xmap ]f <Plug>(LineJugglerDupFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerDupFetchBelow)', 'x')
    xmap [f <Plug>(LineJugglerDupFetchBelow)
endif



nnoremap <silent> <Plug>(LineJugglerRepFetchAbove)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#RepFetch(
\   v:count1,
\   -1,
\   'Above'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerRepFetchBelow) :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#RepFetch(
\   v:count1,
\   1,
\   'Below'
\)<CR>
if ! hasmapto('<Plug>(LineJugglerRepFetchAbove)', 'n')
    nmap ]r <Plug>(LineJugglerRepFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerRepFetchBelow)', 'n')
    nmap [r <Plug>(LineJugglerRepFetchBelow)
endif

vnoremap <silent> <Plug>(LineJugglerRepFetchAbove)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualRepFetch(-1, v:count1, 'Above')<CR>
vnoremap <silent> <Plug>(LineJugglerRepFetchBelow)   :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#VisualRepFetch( 1, v:count1, 'Below')<CR>
if ! hasmapto('<Plug>(LineJugglerRepFetchAbove)', 'x')
    xmap ]r <Plug>(LineJugglerRepFetchAbove)
endif
if ! hasmapto('<Plug>(LineJugglerRepFetchBelow)', 'x')
    xmap [r <Plug>(LineJugglerRepFetchBelow)
endif
" When repeating, replace a same-sized selection starting from the current
" position.
" Don't repeat on a closed fold; just grabbing any invisible part from it is as
" bad as suddenly turning this into a regular, full-line move.
nnoremap <silent> <Plug>(LineJugglerRepFetchIntraAbove) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#RepFetchRepeat(-1, v:count1, 'Above')<CR>
nnoremap <silent> <Plug>(LineJugglerRepFetchIntraBelow) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#IntraLine#RepFetchRepeat( 1, v:count1, 'Below')<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
