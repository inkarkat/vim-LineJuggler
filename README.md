LINE JUGGLER
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin offers mappings to quickly duplicate and move lines to above /
below the current line. A [count] either specifies the number of lines, or the
relative visible target line, therefore it's especially easy to clone lines
when 'relativenumber' is set.
The mappings can save you several keystrokes over an explicit |dd|/
|yy|[{motion}, ...]|p| sequence in cases where the other lines are nearby and
visible in the current window.

Oftentimes, duplication in source code is a code smell. Please use this plugin
responsibly ;-)

### SEE ALSO

- The swap functionality of the plugin's [E / ]E mappings are also
  available as an Ex :Swap command, provided by the companion
  LineJugglerCommands.vim plugin ([vimscript #4465](http://www.vim.org/scripts/script.php?script_id=4465)).
- http://vim.wikia.com/wiki/Quickly_adding_and_deleting_empty_lines has
  a simple implementation of the [&lt;Space&gt; mapping; it also offers mappings
  that delete blank empty lines above / below the current line / selection
  without changing the current position; these can complement the mappings
  provided by this plugin.

### RELATED WORKS

- Idea, design and implementation of the [&lt;Space&gt; and [e mappings are based on
  Tim Pope's unimpaired.vim plugin ([vimscript #1590](http://www.vim.org/scripts/script.php?script_id=1590)). In addition, unimpaired
  provides other, unrelated functionality (all via [... / ]... mappings), but
  doesn't offer customization of the mappings.
- textmanip.vim ([vimscript #3491](http://www.vim.org/scripts/script.php?script_id=3491)) provides mappings to move and duplicate
  (selected / current) line(s).
- upAndDown ([vimscript #2586](http://www.vim.org/scripts/script.php?script_id=2586)) provides mappings to move line(s) / selection up
  or down.
- move ([vimscript #4687](http://www.vim.org/scripts/script.php?script_id=4687)) also provides mappings to move lines / selection
  around.
- vim-schlepp (https://github.com/zirrostig/vim-schlepp), too

USAGE
------------------------------------------------------------------------------

    [<Space>                Add [count] blank lines above the current line / above
                            the start of the selection.
                            In a single-line characterwise-visual selection:
                            Add [count] spaces before the start of the selection.
    "x[<Space>              Prepend [count] blank lines to the contents in
                            register x. Does not work for the default register.

    ]<Space>                Add [count] blank lines below the current line / below
                            the end of the selection.
                            In a single-line characterwise-visual selection:
                            Add [count] spaces after the end of the selection.
    "x]<Space>              Append [count] blank lines to the contents in
                            register x. Does not work for the default register.

    [e                      Move the current line / selection [count] lines above.

    ]e                      Move the current line / selection [count] lines below.
                            In a single-line characterwise-visual selection:
                            Move the selected text to the same start column
                            [count] lines above / below (regardless of whether the
                            target line is that long already; missing columns are
                            filled up with spaces).

    [E                      Exchange the current line with the line / closed fold
                            [count] lines above.
                            Exchange the current closed fold with the same amount
                            of visible lines as are in the fold, [count] lines
                            above.
    {Visual}[E              Exchange the selection with the same amount of visible
                            lines located [count] lines above.
                            In a single-line characterwise-visual selection:
                            Exchange the selected text with the same-sized
                            area [count] lines above.
    ]E                      Exchange the current line with the line / closed fold
                            [count] lines below.
                            Exchange the current closed fold with the same amount
                            of visible lines as are in the fold, [count] lines
                            below.
    {Visual}]E              Exchange the selection with the same amount of visible
                            lines located [count] lines below.
                            In a single-line characterwise-visual selection:
                            Exchange the selected text with the same-sized
                            area [count] lines below.

    [d                      Duplicate the current line / selection directly
                            above / across [count] lines above the current line /
                            above the start of the selection.
                            In a single-line characterwise-visual selection:
                            Duplicate before the selection (to [count] characters
                            before the start of the selection).
    ]d                      Duplicate the current line / selection directly
                            below / across [count] lines below the current line /
                            below the end of the selection.
                            In a single-line characterwise-visual selection:
                            Duplicate after the selection (to [count] characters
                            after the end of the selection).
    [N][d{M}, [N]]d{M}      Duplicate {M} lines across [N] lines. A combination
                            of [d and [D.

    [D                      Duplicate the current  / [count] lines to above the
                            current line.
    {Visual}[D              Duplicate the selection [count] times above the
                            selection.
                            In a single-line characterwise-visual selection:
                            Duplicate before the selection [count] times.
    ]D                      Duplicate the current  / [count] lines to below that
                            range.
    {Visual}]D              Duplicate the selection [count] times below the
                            selection.
                            In a single-line characterwise-visual selection:
                            Duplicate after the selection [count] times.
    [N][D{M}, [N]]D{M}      Duplicate [N] lines across {M} lines. A combination
                            of [d and [D. Equivalent to [N][d{M}, but with
                            reverse order of the numbers.

    [f                      Fetch the line [count] visible lines below the current
                            line and duplicate it below the current line.
    ]f                      Fetch the line [count] visible lines above the current
                            line and duplicate it below the current line.
    {Visual}[f              Fetch the same number of visible lines starting from
                            the line [count] lines below the current line and
                            duplicate them above the start of the selection.
    {Visual}]f              Fetch the same number of visible lines starting from
                            the line [count] lines above the current line and
                            duplicate them below the end of the selection.

    [r                      Fetch the line [count] visible lines below the current
                            line and replace the current line with it.
    ]r                      Fetch the line [count] visible lines above the current
                            line and replace the current line with it.
    {Visual}[r              Replace the selection with the same number of visible
                            lines fetched starting from the line [count] lines
                            below the current line.
    {Visual}]r              Replace the selection with the same number of visible
                            lines fetched starting from the line [count] lines
                            above the current line.
                            In a single-line characterwise-visual selection:
                            Replace the selected text with the same-sized
                            area [count] lines below / above.

                            When the cursor is on a closed fold or the selection
                            contains a closed fold, the entire set of folded lines
                            is used. All mappings treat closed folds as a fixed
                            entity, so they will never move / duplicate into a
                            closed fold, always over it.
                            A [count] specifies visible lines, closed folds are
                            counted as one line, so you can use the
                            'relativenumber' column to easily reach a target.
                            (Except for v_[d and v_]d when at the opposite
                            side of the selection.)

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-LineJuggler
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim LineJuggler*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.022 or
  higher.
- repeat.vim ([vimscript #2136](http://www.vim.org/scripts/script.php?script_id=2136)) plugin (optional)
- visualrepeat.vim ([vimscript #3848](http://www.vim.org/scripts/script.php?script_id=3848)) plugin (optional)

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

If you want to use different mappings, map your keys to the
&lt;Plug&gt;(LineJuggler...) mapping targets _before_ sourcing the script (e.g. in
your vimrc):

    nmap <C-Up>   <Plug>(LineJugglerBlankUp)
    nmap <C-Down> <Plug>(LineJugglerBlankDown)
    vmap <C-Up>   <Plug>(LineJugglerBlankUp)
    vmap <C-Down> <Plug>(LineJugglerBlankDown)
    ...

The [d||[D combination mappings are only defined for low values of {M}. For
how many (and the default mapping keys) are configured via two variables:

    let g:LineJuggler_DupRangeOver= [9, '[%dD', ']%dD']
    let g:LineJuggler_DupOverRange= [9, '[%dd', ']%dd']

The first number specifies the upper limit of {M}; with 0, no combination
mappings are defined. The second and third argument represent the mapping
keys, with the {M} number inserted at the %d.

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-LineJuggler/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 2.12    RELEASEME
- BUG: Exchange via [E sometimes loses lines when folding happens in between
  the two range swaps. Temporarily disable folding during the second
  replacement. Thanks to Ilya Tumaykin for reporting this.
- ENH: Overload [&lt;Space&gt; and ]&lt;Space&gt; to prepend / append blank line(s) to the
  given non-default register.
- Adapt: Compatibility: Adding one character to previous exclusive selection
  not needed since Vim 9.0.1172

##### 2.11    04-Nov-2018
- ]e / [e cause fold update / may close all folds (e.g. in HTML) (after Vim
  7.4.700). Culprit is the :move command; temporarily disable folding during
  its execution to avoid that.
- Move LineJuggler#FoldClosed() and LineJuggler#FoldClosedEnd() into
  ingo-library as ingo#range#NetStart() and ingo#range#NetEnd().

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.022!__

##### 2.10    11-Jun-2014
- ENH: Add combination mappings of ]d and ]D that can specify both a number of
  lines and number of skipped lines (one limited to a small range of 1..9) to
  handle the often-needed use case of duplicating a few lines with a little
  offset, without having to go through visual mode and ]D.
- Expose (most of) s:RepFetch() as LineJuggler#ReplaceRanges() for use with
  the companion LineJugglerCommands.vim plugin.

##### 2.01    19-Dec-2013
- Adapt to changed ingo#register#KeepRegisterExecuteOrFunc() interface.
- FIX: Intra-line ]r and ]E do not work in Vim versions before 7.3.590; need
  to use ingo#compat#setpos().
- XXX: Include workaround for wrong cursor position at the beginning, not the
  end of an intra-line swap to the end of the line, starting with Vim 7.4.034.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.015!__

##### 2.00    14-Nov-2013
- ENH: Implement special DWIM behavior for duplication of characterwise
  single-line selection:
  Add spaces before / after the selection ([&lt;Space&gt; / ]&lt;Space&gt;).
  Duplicate before / after the selection in the same line, either with [count]
  as character offset ([d / ]d) or repeat count ([D / ]D).
  Move only selection above / below ([e / ]e).
  Exchange only selection above / below ([E / ]E).
  Replace selection with text from above / below (]r / [r).

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.014!__

##### 1.23    26-Oct-2013
- Add message "N lines swapped with M lines" on [E / ]E.
- Add message "Replaced N lines" for [r / ]r.
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.004 (or higher)!__

##### 1.22    08-Mar-2013
- Expose s:DoSwap() as LineJuggler#SwapRanges() for use with the companion
  LineJugglerCommands.vim plugin.

##### 1.21    03-Sep-2012
- Avoid clobbering the expression register.

##### 1.20    27-Jul-2012
- CHG: [d / ]d duplication without [count] still duplicates to the directly
  adjacent line, but with [count] now across [count] lines, which aligns with
  the 'relativenumber' hint.
- FIX: Correct clipping at the end for the ]E mapping.
- FIX: Make sure that v\_[E / v\_]E never swap with a single folded target line;
  this special behavior is reserved for the single-line normal mode swap.
- CHG: For visual selections in v\_[E, v\_[f, v\_[r, also use the amount of
  visible lines, not the number of lines contained in the selection. This
  makes it more consistent with the overall plugin behavior and is hopefully
  also more useful.
- The workaround in s:PutWrapper() is not necessary after Vim version 7.3.272;
  add conditional.

##### 1.10    23-Jul-2012
- CHG: Split [f and {Visual}[f behaviors into two families of mappings:
a) [f to fetch below current line and {Visual}[f to fetch selected number of
   lines above/below selection
b) [r to fetch and replace current line / selection.

##### 1.00    20-Jul-2012
- Initial release.

##### 0.01    12-Mar-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2024 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
