" Test exchanging folded multi-line visual selection down with folded text.
" Tests that the closed folds in the selection are counted as one line each, not
" the number of contained lines.
" Tests that the cursor moves to the end of the original selected lines and moves to column 1.

" XXX: Wrong results when running with :normal, Vim 7.3.600.
"execute '3normal V2j10]E'
"call Quit()
3call feedkeys("V2j10]E:call Quit()\<CR>")
