" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
"   - repeat.vim (vimscript #2136) autoload script (optional)
"   - visualrepeat.vim (vimscript #3848) autoload script (optional)
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	12-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_LineJuggler') || (v:version < 700)
    finish
endif
let g:loaded_LineJuggler = 1

function! s:BlankUp(count) abort
    put! =repeat(nr2char(10), a:count)
    ']+1
    silent! call repeat#set("\<Plug>LineJugglerBlankUp", a:count)
endfunction
function! s:BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
    silent! call repeat#set("\<Plug>LineJugglerBlankDown", a:count)
endfunction

nnoremap <silent> <Plug>LineJugglerBlankUp   :<C-U>call <SID>BlankUp(v:count1)<CR>
nnoremap <silent> <Plug>LineJugglerBlankDown :<C-U>call <SID>BlankDown(v:count1)<CR>
if ! hasmapto('<Plug>LineJugglerBlankUp', 'n')
    nmap [<Space> <Plug>LineJugglerBlankUp
endif
if ! hasmapto('<Plug>LineJugglerBlankDown', 'n')
    nmap ]<Space> <Plug>LineJugglerBlankDown
endif



function! s:Move(cmd, count, map) abort
    normal! m`
    execute 'move' a:cmd . a:count
    normal! g``
    silent! call repeat#set("\<Plug>LineJugglerMove" . a:map, a:count)
    silent! call visualrepeat#set("\<Plug>LineJugglerMove" . a:map, a:count)
endfunction

nnoremap <silent> <Plug>LineJugglerMoveUp   :<C-U>call <SID>Move('--',v:count1,'Up')<CR>
nnoremap <silent> <Plug>LineJugglerMoveDown :<C-U>call <SID>Move('+',v:count1,'Down')<CR>
xnoremap <silent> <Plug>LineJugglerMoveUp   :<C-U>execute 'normal! m`'<Bar>execute '''<,''>move --' . v:count1<CR>g``
xnoremap <silent> <Plug>LineJugglerMoveDown :<C-U>execute 'normal! m`'<Bar>execute '''<,''>move ''>+' . v:count1<CR>g``
if ! hasmapto('<Plug>LineJugglerMoveUp', 'n')
    nmap [e <Plug>LineJugglerMoveUp
endif
if ! hasmapto('<Plug>LineJugglerMoveDown', 'n')
    nmap ]e <Plug>LineJugglerMoveDown
endif
if ! hasmapto('<Plug>LineJugglerMoveUp', 'x')
    xmap [e <Plug>LineJugglerMoveUp
endif
if ! hasmapto('<Plug>LineJugglerMoveDown', 'x')
    xmap ]e <Plug>LineJugglerMoveDown
endif



function! s:Dup(insLnum, lines, isUp, count, map) abort
    if a:isUp
	let l:lnum = max([0, a:insLnum - a:count + 1])
	execute l:lnum.'put!' '=a:lines'
    else
	let l:lnum = min([line('$'), a:insLnum + a:count - 1])
	execute l:lnum.'put' '=a:lines'
    endif

    silent! call repeat#set("\<Plug>LineJugglerDup".a:map, a:count)
    silent! call visualrepeat#set("\<Plug>LineJugglerDup".a:map, a:count)
endfunction

nnoremap <silent> <Plug>LineJugglerDupUp   :<C-U>call <SID>Dup(line('.'),  getline('.'),        1, v:count1, 'Up'  )<CR>
nnoremap <silent> <Plug>LineJugglerDupDown :<C-U>call <SID>Dup(line('.'),  getline('.'),        0, v:count1, 'Down')<CR>
vnoremap <silent> <Plug>LineJugglerDupUp   :<C-U>call <SID>Dup(line("'<"), getline("'<", "'>"), 1, v:count1, 'Up'  )<CR>
vnoremap <silent> <Plug>LineJugglerDupDown :<C-U>call <SID>Dup(line("'>"), getline("'<", "'>"), 0, v:count1, 'Down')<CR>
if ! hasmapto('<Plug>LineJugglerDupUp', 'n')
    nmap [d <Plug>LineJugglerDupUp
endif
if ! hasmapto('<Plug>LineJugglerDupDown', 'n')
    nmap ]d <Plug>LineJugglerDupDown
endif
if ! hasmapto('<Plug>LineJugglerDupUp', 'x')
    xmap [d <Plug>LineJugglerDupUp
endif
if ! hasmapto('<Plug>LineJugglerDupDown', 'x')
    xmap ]d <Plug>LineJugglerDupDown
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
