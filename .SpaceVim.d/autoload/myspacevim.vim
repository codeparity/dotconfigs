function! myspacevim#before() abort
    " you can defined mappings in bootstrap function
    " for example, use kj to exit insert mode.
    set mouse=v
    tnoremap <esc>  <C-\><C-n>
    tnoremap <C-]> <C-\><C-n>:q<Cr> 
endfunction

function! myspacevim#after() abort
    " you can remove key binding in bootstrap_after function
endfunction
