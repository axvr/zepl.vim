" =====================================================
" Description:  Simple REPL in Vim.
" File:         plugin/zepl.vim
" =====================================================

command! -nargs=* -count -complete=shellcmd Repl call zepl#start(<q-args>, <q-mods>, <count>)

function! s:send_region_or_text(text, ...) abort
    let text = (a:text !=# '' ? a:text : join(getline(a:1, a:2), "\n"))
    call zepl#send(text)
endfunction
command! -range -nargs=* ReplSend call <SID>send_region_or_text(<q-args>, <line1>, <line2>)

nnoremap <silent> <Plug>ReplSendRegion :<C-u>set operatorfunc=zepl#send_region<CR>g@
nnoremap <silent> <Plug>ReplSendNewline :<C-u>call zepl#send_newline()<CR>
nnoremap <silent> <Plug>ReplSendCtrlC :<C-u>call zepl#send_sigint()<CR>
nnoremap <silent> <Plug>ReplSendCtrlD :<C-u>call zepl#send_eof()<CR>
vnoremap <silent> <Plug>ReplSendVisual :<C-u>call zepl#send_region(visualmode(), 1)<CR>
nnoremap <silent> <Plug>ReplFocus :<C-u>call zepl#focus()<CR>

if get(b:, 'zepl_default_maps', get(g:, 'zepl_default_maps', 1)) && maparg('gz', 'n') ==# ''
    nmap <silent> gz <Plug>ReplSendRegion
    vmap <silent> gz <Plug>ReplSendVisual
    nmap <silent> gzz gz_
    nmap <silent> gzZ gz$
    nmap <silent> gz<CR> <Plug>ReplSendNewline
    nmap <silent> gzc <Plug>ReplSendCtrlC
    nmap <silent> gzq <Plug>ReplSendCtrlD
    nmap <silent> gz<TAB> <Plug>ReplFocus
endif
