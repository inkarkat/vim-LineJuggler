" Test normal mode repeat of duplicating 3 lines down over 2 lines.
" Tests that both [count] (3) and number of skipped lines (2) are remembered.

11normal w3]2D
2normal .

call Quit()
