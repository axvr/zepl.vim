" ===================== ZEPL.VIM =====================
" Repository:   <https://github.com/axvr/zepl.vim>
" File:         plugin/zepl.vim
" Author:       Alex Vear <av@axvr.io>
" Legal:        No rights reserved.  Public domain.
" ====================================================

command! -nargs=* -count -complete=shellcmd Repl call zepl#start(<q-args>, <q-mods>, <count>)

function! s:send_region_or_text(text, ...) abort
    call zepl#send((a:text !=# '' ? a:text : getline(a:1, a:2)), len(a:3))
endfunction
command! -range -bang -nargs=* ReplSend call <SID>send_region_or_text(<q-args>, <line1>, <line2>, <q-bang>)

nnoremap <silent> <Plug>ReplSendRegion :<C-u>set operatorfunc=zepl#send_region<CR>g@
nnoremap <silent> <Plug>ReplSendNewline :<C-u>call zepl#send("\u0d", 1)<CR>
nnoremap <silent> <Plug>ReplSendCtrlC :<C-u>call zepl#send("\u03", 1)<CR>
nnoremap <silent> <Plug>ReplSendCtrlD :<C-u>call zepl#send("\u04", 1)<CR>
vnoremap <silent> <Plug>ReplSendVisual :<C-u>call zepl#send_region(visualmode(), 1)<CR>
nnoremap <silent> <Plug>ReplFocus :<C-u>call zepl#jump()<CR>

if get(g:, 'zepl_default_maps', 1)
    nmap <silent> gz <Plug>ReplSendRegion
    vmap <silent> gz <Plug>ReplSendVisual
    nmap <silent> gzz gz_
    nmap <silent> gzZ gz$
    nmap <silent> gz<CR> <Plug>ReplSendNewline
    nmap <silent> gzc <Plug>ReplSendCtrlC
    nmap <silent> gzq <Plug>ReplSendCtrlD
    nmap <silent> gz<TAB> <Plug>ReplFocus
endif
