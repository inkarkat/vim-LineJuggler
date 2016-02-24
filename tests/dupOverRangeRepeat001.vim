" Test normal mode repeat of duplicating 3 lines down over 2 lines.
" Tests that both [count] (2) and number of skipped lines (3) are remembered.

11normal w2]3d
2normal .

call Quit()
