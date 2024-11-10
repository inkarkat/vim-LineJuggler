" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - LineJuggler.vim autoload script
"   - ingo/folds.vim autoload script
"   - ingo/range.vim autoload script
"
" Copyright: (C) 2012-2024 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_LineJuggler') || (v:version < 700)
    finish
endif
let g:loaded_LineJuggler = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:LineJuggler_DupRangeOver')
    let g:LineJuggler_DupRangeOver= [9, '[%dD', ']%dD']
endif
if ! exists('g:LineJuggler_DupOverRange')
    let g:LineJuggler_DupOverRange= [9, '[%dd', ']%dd']
endif


"- mappings --------------------------------------------------------------------

nnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#Blank('', v:count1, -1, v:register, 'Up')<CR>
nnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#Blank('', v:count1,  1, v:register, 'Down')<CR>
vnoremap <silent> <Plug>(LineJugglerBlankUp)   :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#VisualBlank("'<", -1, v:count1, '', 'Up')<CR>
vnoremap <silent> <Plug>(LineJugglerBlankDown) :<C-u>call setline('.', getline('.'))<Bar>call LineJuggler#VisualBlank("'>",  1, v:count1, '', 'Down')<CR>
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
\   ingo#range#NetStart() . ',' . ingo#range#NetEnd(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1, -1) - 1,
\   v:count1,
\   -1,
\   'Up'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerMoveDown) :<C-u>if !&ma<Bar><Bar>&ro<Bar>call setline('.', getline('.'))<Bar>endif<Bar>
\call LineJuggler#Move(
\   ingo#range#NetStart() . ',' . ingo#range#NetEnd(),
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
\   ingo#range#NetStart(), ingo#range#NetEnd(),
\   ingo#folds#RelativeWindowLine(line('.'), v:count1, -1),
\   v:count1,
\   -1,
\   'Up'
\)<CR>
nnoremap <silent> <Plug>(LineJugglerSwapDown)   :<C-u>call setline('.', getline('.'))<Bar>
\call LineJuggler#Swap(
\   ingo#range#NetStart(), ingo#range#NetEnd(),
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

for s:cnt in range(1, g:LineJuggler_DupOverRange[0])
    execute printf("nnoremap <silent> <Plug>(LineJugglerDupOverRange%dUp)" .
    \" :<C-u>call setline('.', getline('.'))<Bar>" .
    \"call LineJuggler#DupRangeOver(" .
    \   "%d," .
    \   "v:count1," .
    \   "-1," .
    \   "'OverRange%dUp'," .
    \   "v:count1" .
    \")<CR>",
    \   s:cnt, s:cnt, s:cnt)
    execute printf("nnoremap <silent> <Plug>(LineJugglerDupOverRange%dDown)" .
    \" :<C-u>call setline('.', getline('.'))<Bar>" .
    \"call LineJuggler#DupRangeOver(" .
    \   "%d," .
    \   "v:count1," .
    \   "1," .
    \   "'OverRange%dDown'," .
    \   "v:count1" .
    \")<CR>",
    \   s:cnt, s:cnt, s:cnt)
    execute printf('nmap ' . g:LineJuggler_DupOverRange[1] . ' <Plug>(LineJugglerDupOverRange%dUp)',   s:cnt, s:cnt)
    execute printf('nmap ' . g:LineJuggler_DupOverRange[2] . ' <Plug>(LineJugglerDupOverRange%dDown)', s:cnt, s:cnt)
endfor



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

for s:cnt in range(1, g:LineJuggler_DupRangeOver[0])
    execute printf("nnoremap <silent> <Plug>(LineJugglerDupRangeOver%dUp)" .
    \" :<C-u>call setline('.', getline('.'))<Bar>" .
    \"call LineJuggler#DupRangeOver(" .
    \   "v:count1," .
    \   "%d," .
    \   "-1," .
    \   "'RangeOver%dUp'," .
    \   "v:count1" .
    \")<CR>",
    \   s:cnt, s:cnt, s:cnt)
    execute printf("nnoremap <silent> <Plug>(LineJugglerDupRangeOver%dDown)" .
    \" :<C-u>call setline('.', getline('.'))<Bar>" .
    \"call LineJuggler#DupRangeOver(" .
    \   "v:count1," .
    \   "%d," .
    \   "1," .
    \   "'RangeOver%dDown'," .
    \   "v:count1" .
    \")<CR>",
    \   s:cnt, s:cnt, s:cnt)
    execute printf('nmap ' . g:LineJuggler_DupRangeOver[1] . ' <Plug>(LineJugglerDupRangeOver%dUp)',   s:cnt, s:cnt)
    execute printf('nmap ' . g:LineJuggler_DupRangeOver[2] . ' <Plug>(LineJugglerDupRangeOver%dDown)', s:cnt, s:cnt)
endfor



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
unlet s:save_cpo s:cnt
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
