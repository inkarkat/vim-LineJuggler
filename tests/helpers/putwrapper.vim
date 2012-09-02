runtime plugin/SidTools.vim
silent! call LineJuggler#DoesNotExist()
let s:SID = Sid('autoload/LineJuggler.vim')

function! PutWrapper( ... )
    return SidInvoke(s:SID, 'PutWrapper(' . join(map(copy(a:000), 'string(v:val)'), ',') . ')')
endfunction
