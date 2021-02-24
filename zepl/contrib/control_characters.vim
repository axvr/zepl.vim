" Description:  Send control characters to the REPL and easily focus it.
" File:         zepl/contrib/control_characters.vim
" Help:         :help zepl-load_files
" Legal:        No rights reserved.  Public domain.
"
function! s:jump_also_to_tab() abort
  let swb = &switchbuf
  set switchbuf+=usetab
  call zepl#jump()
  let &switchbuf=swb
endfunction

command! -nargs=0 ReplSendNewline call zepl#send("\u0d", 1)
command! -nargs=0 ReplSendCtrlC call zepl#send("\u03", 1)
command! -nargs=0 ReplSendCtrlD call zepl#send("\u04", 1)
command! -nargs=0 ReplFocus call s:jump_also_to_tab()
nnoremap <silent> <Plug>ReplSendNewline :<C-u>ReplSendNewline<CR>
nnoremap <silent> <Plug>ReplSendCtrlC :<C-u>ReplSendCtrlC<CR>
nnoremap <silent> <Plug>ReplSendCtrlD :<C-u>ReplSendCtrlD<CR>
nnoremap <silent> <Plug>ReplFocus :<C-u>ReplFocus<CR>

if get(g:, 'zepl_default_maps', 1)
  nmap <silent> gz<CR> <Plug>ReplSendNewline
  nmap <silent> gzc <Plug>ReplSendCtrlC
  nmap <silent> gzq <Plug>ReplSendCtrlD
  nmap <silent> gz<TAB> <Plug>ReplFocus
endif
