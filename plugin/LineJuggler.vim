" LineJuggler.vim: Duplicate and move around lines.
"
" DEPENDENCIES:
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
