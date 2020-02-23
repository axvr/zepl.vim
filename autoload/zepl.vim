" =====================================================
" Description:  Simple REPL in Vim.
" File:         autoload/zepl.vim
" =====================================================

let s:repl_bufnr = 0

function! s:error(msg) abort
    echohl ErrorMsg
    echo a:msg
    echohl NONE
endfunction

function! zepl#start(cmd, mods, size) abort
    let term_options = {
                \ 'term_finish': 'close',
                \ 'close_cb': function('<SID>repl_closed'),
                \ 'hidden': 1
                \ }

    if a:cmd !=# ''
        if s:repl_bufnr
            call s:error('REPL already running')
            return
        endif

        let cmd = a:cmd
    elseif exists('b:repl_config') && has_key(b:repl_config, 'cmd')
        let cmd = b:repl_config['cmd']
    else
        call s:error('No REPL configured')
        return
    endif

    if !s:repl_bufnr
        let term_options['term_name'] = printf('zepl: %s', cmd)
        let s:repl_bufnr = term_start(cmd, term_options)
    endif

    call zepl#jump(a:mods, a:size)
endfunction

function! s:repl_closed(channel) abort
    let s:repl_bufnr = 0
endfunction

function! zepl#jump(mods, size) abort
    if !s:repl_bufnr
        call s:error('No active REPL')
        return
    endif

    for mod in expand(a:mods, 0, 1)
        if mod ==# 'hide'
            return
        endif
    endfor

    let swb = &switchbuf
    set switchbuf+=useopen

    execute a:mods . ' sbuffer ' . s:repl_bufnr

    if a:size
        execute a:mods . ' resize ' . a:size
    endif

    let &switchbuf = swb
endfunction

function! zepl#send(text) abort
    if !s:repl_bufnr
        call s:error('No active REPL')
        return
    endif

    let text = trim(a:text) . "\n"
    for l in split(text,'\n\zs')
        call term_sendkeys(s:repl_bufnr, l)
        call term_wait(s:repl_bufnr)
    endfor
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

function! zepl#send_region(type, ...) abort
    let sel_save = &selection
    let &selection = 'inclusive'

    if a:0  " Visual mode
        let lines = s:get_text("'<", "'>", visualmode())
    else
        let lines = s:get_text("'[", "']", a:type)
    endif

    call zepl#send(join(lines, "\n"))

    let &selection = sel_save
endfunction
