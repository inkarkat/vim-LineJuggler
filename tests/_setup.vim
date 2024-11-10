if ! vimtest#features#SupportsNormalWithCount()
    call vimtest#BailOut('All mappings of LineJuggler need support for :normal with count')
endif

call vimtest#AddDependency('vim-ingo-library')
if g:runVimTest =~# 'Repeat'
    call vimtest#AddDependency('vim-repeat')
    call vimtest#AddDependency('vim-visualrepeat')
endif

runtime plugin/LineJuggler.vim

function! Mark( ... )
    if a:0 && a:1
	normal! my
	normal! g`]mzg`[r[g`zr]
	normal! g`<r<g`>r>
	normal! g`y
    endif
    normal! r*
endfunction
function! Quit( ... )
    call call('Mark', a:000)
    call vimtest#SaveOut()
    call vimtest#Quit()
endfunction

insert
01 first line
02 ---
03     TWO-LINE block A start
04     TWO-LINE block A end
05 -- -- -- --
06     TWO-LINE block B start
07     TWO-LINE block B end
08 - - - - - -
09 just some text
10 to fill the buffer
11 and offer
12 lines lines lines
13 to experiment
14     THREE-LINE block C start
15     THREE-LINE block C middle
16     THREE-LINE block C end
17 -  -  -  -  -
18     SINGLE LINE
19 filler text
20 and so on
21 if (flag) {
22     frobnize();
23     globify();
24 } else {
25     humanate();
26 }
27 if (goo)
28     iluminate();
29 --  --  --
30 last line
.

3,4fold
6,7fold
14,16fold
22,23fold
21,26fold
27,28fold
