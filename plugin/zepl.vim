" =====================================================
" Description:  Simple REPL in Vim.
" File:         plugin/zepl.vim
" =====================================================

command! -nargs=* -count -complete=shellcmd Repl call zepl#start(<q-args>, <q-mods>, <count>)

function! s:send_region_or_text(text, ...) abort
    call zepl#send((a:text !=# '' ? a:text : getline(a:1, a:2)))
endfunction
command! -range -nargs=* ReplSend call <SID>send_region_or_text(<q-args>, <line1>, <line2>)

nnoremap <silent> <Plug>ReplSendRegion :<C-u>set operatorfunc=zepl#send_region<CR>g@
vnoremap <silent> <Plug>ReplSendVisual :<C-u>call zepl#send_region(visualmode(), 1)<CR>

if get(b:, 'zepl_default_maps', get(g:, 'zepl_default_maps', 1)) && maparg('gz', 'n') ==# ''
    nmap <silent> gz <Plug>ReplSendRegion
    vmap <silent> gz <Plug>ReplSendVisual
    nmap <silent> gzz gz_
    nmap <silent> gzZ gz$
endif
