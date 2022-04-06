" ===================== ZEPL.VIM =====================
" Repository:   <https://github.com/axvr/zepl.vim>
" File:         autoload/zepl.vim
" Author:       Alex Vear <alex@vear.uk>
" Legal:        No rights reserved.  Public domain.
" ====================================================

let s:repl_bufnr = 0

function! s:error(msg) abort
    echohl ErrorMsg | echo a:msg | echohl NONE
endfunction

" zepl#start(cmd [, {mods} [, {size}]])
function! zepl#start(cmd, ...) abort
    if s:repl_bufnr && !empty(a:cmd)
        call s:error('REPL already running')
        return

    elseif !s:repl_bufnr
        let cmd = (empty(a:cmd) ? zepl#config('cmd', '') : a:cmd)

        if empty(cmd)
            call s:error('No command specified')
            return
        endif

        let name = printf('zepl: %s', cmd)

        if has('nvim')
            " XXX: Hacky code to make Neovim's terminal to behave like Vim's.
            set hidden | split | enew
            call termopen(cmd, {'on_exit': function('<SID>repl_closed')})
            exec 'file ' . name | let b:term_title = name
            let s:repl_bufnr = bufnr('%')
            quit
        else
            let s:repl_bufnr = term_start(cmd, {
                        \ 'term_name': name,
                        \ 'term_finish': 'close',
                        \ 'close_cb': function('<SID>repl_closed'),
                        \ 'norestore': 1,
                        \ 'hidden': 1
                        \ })
        endif
    endif

    call zepl#jump(get(a:, 1, ''), get(a:, 2, 0))
endfunction

function! s:repl_closed(...) abort
    let s:repl_bufnr = 0
endfunction

" zepl#jump([{mods} [, {size}]])
function! zepl#jump(...) abort
    if !s:repl_bufnr
        call s:error('No active REPL')
        return
    endif

    let mods = get(a:, 1, '')
    let size = get(a:, 2, 0)

    let expanded_mods = split(expand(mods, 0, 0), '\s\+')

    " Open REPL in background buffer.
    if count(expanded_mods, 'hide')
        return
    endif

    let curtab = tabpagenr()
    let swb = &switchbuf
    set switchbuf+=useopen

    execute mods . ' sbuffer ' . s:repl_bufnr

    if !get(b:, 'zepl_done_autocmd', 0) && exists('#User#ZeplTerminalWinOpen')
        let b:zepl_done_autocmd = 1
        doautocmd <nomodeline> User ZeplTerminalWinOpen
    endif

    if size
        execute mods . ' resize ' . size
    endif

    if has('nvim')
        startinsert
    endif

    let &switchbuf = swb

    " 'keep' focus in previous buffer.
    if count(expanded_mods, 'keepalt') || count(expanded_mods, 'keepmarks')
        if tabpagenr() != curtab
            exec 'tabnext' curtab
        else
            wincmd p
        endif
    endif
endfunction

function! zepl#config(option, default)
    return get(get(b:, 'repl_config',
        \          get(get(g:, 'repl_config', {}), &ft, {})),
        \      a:option, a:default)
endfunction

function! zepl#generic_formatter(lines)
    return trim(join(a:lines, "\<CR>")) . "\<CR>"
endfunction

" zepl#send({text} [, {verbatim}])
function! zepl#send(text, ...) abort
    if !s:repl_bufnr
        call s:error('No active REPL')
        return
    endif

    let text = a:text
    let verbatim = get(a:, 1, 0)

    if !verbatim
        if type(text) != v:t_list
            let text = split(text, '\m\C[\n\r]\zs', 1)
        endif

        let text = zepl#config('formatter', function('zepl#generic_formatter'))(text)
    endif

    if has('nvim')
        call chansend(getbufvar(s:repl_bufnr, '&channel'), text)
    else
        let text = split(text, '\m\C[\r\n]\+\zs', 1)

        for line in text
            " 'firstchar' is a fix for rlwrap incorrectly detecting prompts.
            " See: <https://github.com/axvr/zepl.vim/issues/9>
            let firstchar = 1
            for char in line
                call term_sendkeys(s:repl_bufnr, char)
                if firstchar
                    call term_wait(s:repl_bufnr, 1)
                    let firstchar = 0
                endif
            endfor
            call term_wait(s:repl_bufnr)
        endfor
    endif
endfunction

function! s:get_text(start, end, mode) abort
    let [b, start_line, start_col, o] = getpos(a:start)
    let [b, end_line, end_col, o] = getpos(a:end)

    " Correct column indexes
    if a:mode ==# 'V' || a:mode ==# 'line'
        let [start_col, end_col] = [0, -1]
    else
        let [start_col, end_col] = [start_col - 1, end_col - 1]
    endif

    let lines = getline(start_line, end_line)
    let lines[-1] = lines[-1][:end_col]
    let lines[0] = lines[0][start_col:]

    return lines
endfunction

" XXX: This function is not intended for external use.
function! zepl#send_region(type, ...) abort
    let sel_save = &selection
    let &selection = 'inclusive'

    if a:0  " Visual mode
        let lines = s:get_text("'<", "'>", visualmode())
    else
        let lines = s:get_text("'[", "']", a:type)
    endif

    call zepl#send(lines)

    let &selection = sel_save
endfunction
